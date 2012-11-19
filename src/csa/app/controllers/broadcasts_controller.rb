class BroadcastsController < ApplicationController
  # This is an admin specific controller, so enforce access by admin only
  # This is a very simple form of authorisation
  before_filter :admin_required

  # Default number of entries per page
  PER_PAGE = 12

  # GET /broadcasts
  # GET /broadcasts.json
  def index
    @broadcasts = Broadcast.paginate page: params[:page],
                                     per_page: params[:per_page],
                                     order: 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @broadcasts.to_json({ :include => [:feeds] }) }
    end
  end

  # GET /broadcasts/1
  # GET /broadcasts/1.json
  def show
    @broadcast = Broadcast.find(params[:id])
    @current_page = params[:page] || 1

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render json: @broadcast.to_json( {
          :include => [:feeds]
        } )
      }
    end
  end

  # GET /broadcasts/new
  # Return a form to browsers to allow broadcasting of a news item. Provides
  # the key functionality of this application
  def new

    @broadcast = Broadcast.new
    @current_page = params[:page] || 1

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /broadcasts
  # POST /broadcasts.json
  def create
    @current_page = params[:page] || 1

    @broadcast = Broadcast.new(params[:broadcast])

    # Wire up broadcast with the current user (an administrator)
    # Will be an admin user (see before_filter)
    # Note the current_user is a user_detail object so we need
    # to navigate to its user object
    @broadcast.user = current_user.user

    # Doing the next line forces a save automatically. I want to defer this
    # until the "if" statement
    #current_user.user.broadcasts << @broadcast

    no_errors = false
    respond_to do |format|
      if @broadcast.save

        # Only after saving do we try and do the real broadcast. Could have been
        # done using an observer, but I wanted this to be more explicit

        results = BroadcastService.broadcast(@broadcast, params[:feeds])
        if results.length > 0
          # Something went wrong when trying to broadcast to one or more of the
          # feeds.
          @broadcast.errors[:base] << ("#{I18n.t('broadcasts.unable-message')}: #{results.inspect}")
          flash[:error] = I18n.t('broadcasts.saved-but-message')
        else
          flash[:notice] = I18n.t('broadcasts.saved-message')
          no_errors = true
        end
        if no_errors
          format.html { redirect_to(broadcasts_url(page: @current_page)) }
          format.json { render json: @broadcast, status: :created, location: @broadcast }
        else
          format.html { render action: "new" }
          format.xml {
            # Either say it partly worked but send back the errors or else send
            # back complete failure indicator (couldn't even save)
            if results
              render json: @broadcast.errors, status: :created, location: @broadcast
            else
              render json: @broadcast.errors, status: :unprocessable_entity
            end
          }
        end
      end
    end
  end


  # DELETE /broadcasts/1
  # DELETE /broadcasts/1.json
  def destroy
    begin
      @broadcast = Broadcast.find(params[:id])
      @broadcast.destroy
    rescue ActiveRecord::RecordNotFound
      # Silently ignore issue where record already deleted by someone else
      # The redirect will refresh their page correctly
    end

    current_page = params[:page] || 1

    respond_to do |format|
      format.html { redirect_to(broadcasts_url(page: current_page)) }
      format.json { head :no_content }
    end
  end
end
