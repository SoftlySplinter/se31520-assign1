class UsersController < ApplicationController
  # Since dealing with sensitive data we use SSL. ssl_exceptions without
  # any listed actions will mean that all actions must be protected by SSL
  ssl_exceptions if SSL_SERVER_BEING_USED

  before_filter :admin_required, only: [:index, :search, :destroy]

  def current
    respond_to do |format|
      format.json { render json: User.find(current_user.id) }
    end
  end

  def search
    # Use will_paginate's :conditions and :joins to search across both the
    # users and user_details tables. search_fields private method will add a field
    # for each checkbox field checked by the user, or returns nil
    # if none were checked. The search_conditions method is defined
    # in lib/searchable.rb and either searches across all columns identified in
    # User.searchable_by or uses the search_fields to constrain the search

    respond_to do |format|
      format.html {
        @users = User.paginate page: params[:page],
                               per_page: params[:per_page],
                               joins: :user_detail,
                               conditions: User.search_conditions(params[:q], search_fields(User)),
                               order: 'surname, firstname'
        render 'index'
      }
      # Deal with incoming Ajax request for JSON data for autocomplete search field
      format.json {
        @current_page = params[:page] || 1
        @users = User.where(User.search_conditions(params[:q], search_fields(User))).joins(:user_detail).order('surname, firstname')
      }
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate page: params[:page],
                           per_page: params[:per_page],
                           order: 'surname, firstname'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  # Can be called either by an admin to show any user account or else by
  # a specific user to show their own account, but no one else's
  def show
    @user = User.find(params[:id])
    if current_user.id == @user.id || is_admin?
      @current_page = params[:page] || 1

      respond_to do |format|

        format.js { render partial: 'show_local',
                           locals: {user: @user, current_page: @current_page},
                           layout: false }
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      indicate_illegal_request I18n.t('users.not-your-account')
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @user.user_detail = UserDetail.new
    @current_page = params[:page] || 1

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  # Can be called either by an admin to edit any user account or else by
  # a specific user to edit their own account, but no one else's
  def edit
    @current_page = params[:page] || 1

    @user = User.find(params[:id])
    if current_user.id == @user.id || is_admin?
      respond_to do |format|
        format.html # edit.html.erb
      end
    else
      indicate_illegal_request I18n.t('users.not-your-account')
    end
  rescue ActiveRecord::RecordNotFound # Has been deleted by someone else
    respond_to do |format|
      format.html {
        flash[:error] = I18n.t('users.account-no-exists-edit')
        redirect_to(users_url(page: @current_page))
      }
    end
  end

  # POST /users
  # POST /users.json
  # At the moment we are only allowing the admin user to create new
  # accounts.
  def create
    @current_page = params[:page] || 1

    # This will also create the dependent UserDetail object due to the fields_for
    # helper in new.html.erb and the has_one :user_detail and
    # accepts_nested_attributes_for :user_detail calls in the User model class
    @user = User.new(params[:user])

    # Only create a new image if the :image_file parameter 
    # was specified
    @image = Image.new(photo: params[:image_file]) if params[:image_file]

    # The ImageService model wraps up application logic to 
    # handle saving images correctly
    @service = ImageService.new(@user, @image)
    respond_to do |format|
      if @service.save # Will attempt to save user and image
        format.html { redirect_to(user_url(@user, page: @current_page),
                                  notice: I18n.t('users.account-created')) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  # Can be called either by an admin to update any user account or else by
  # a specific user to update their own account, but no one else's
  def update
    @current_page = params[:page] || 1

    @user = User.find(params[:id])
    if current_user.id == @user.id || is_admin?
      @image = @user.image
      @service = ImageService.new(@user, @image)
      respond_to do |format|
        if @service.update_attributes(params[:user], params[:image_file])
          format.html { redirect_to(user_url(@user, page: @current_page),
                                    notice: I18n.t('users.account-created')) }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      indicate_illegal_request I18n.t('users.not-your-account')
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html {
        redirect_to(users_url(page: @current_page),
                    notice: I18n.t('users.account-no-exists-update'))
      }
      format.json {
        render json: "{#{I18n.t('users.account-no-exists-update')}}",
               status: :unprocessable_entity
      }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user = User.find(params[:id])
      @user.destroy
    rescue ActiveRecord::RecordNotFound
      # Silently ignore issue where record already deleted by someone else
      # The redirect will refresh their page correctly
    end

    @current_page = params[:page] || 1
    respond_to do |format|
      # TODO: At some point do a check to see if there are no items left on the current
      # page and if so and page > 1, then decrement current page by 1

      format.html { redirect_to users_url(page: @current_page) }
      format.json { head :no_content }
    end
  end

  private

  def search_fields(table)
    fields = []
    table.search_columns.each do |column|
      # The parameters have had the table name stripped off so we
      # have to to the same to each search_columns column
      fields << column if params[column.sub(/^.*\./, "")]
    end
    fields = nil unless fields.length > 0
    fields
  end

  def indicate_illegal_request(message)
    respond_to do |format|
      format.html {
        flash[:error] = message
        redirect_back_or_default(home_url)
      }
      format.json {
        render json: "{#{message}}",
               status: :unprocessable_entity
      }
    end
  end
end
