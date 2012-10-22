class RegistrationController < ApplicationController
  skip_before_filter :login_required
  def register
    response do |format|
      format.html
    end
  end

  def unregister
  end
end
