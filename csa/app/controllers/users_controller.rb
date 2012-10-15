class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate page: params[:page],
                           per_page: params[:per_page],
                           order:'surname, firstname'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @current_page = params[:page] || 1

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @current_page = params[:page] || 1

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @current_page = params[:page] || 1
      
    begin
        @user = User.find(params[:id])
        respond_to do |format|
            format.html # edit.html.erb
        end
    rescue ActiveRecord::RecordNotFound # Has been deleted by someone else
        respond_to do |format|
            format.html {
                flash[:error] = 'Account no longer exists; cannot edit'
                redirect_to(users_url(page: @current_page))
            }
        end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @current_page = params[:page] || 1
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(user_url(@user, page: @current_page), 
                                  notice: 'Account was successfully created') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @current_page = params[:page] || 1
      
    begin
        @user = User.find(params[:id])
        respond_to do |format|
            if @user.update_attributes(params[:user])
                format.html { redirect_to(user_url(@user, page: @current_page),
                                          notice: 'Account was successfully updated.') }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
              format.html {
                  redirect_to(users_url(page: @current_page),
                              notice: 'Account no longer exists, not updated.')
              }
              format.json  {
                  render json: '{Account no longer exists, not updated.}',
                         status: :unprocessable_entity
              }
        end
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
end
