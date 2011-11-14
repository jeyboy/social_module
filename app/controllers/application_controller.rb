class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :services

  def services
    @services = current_user ? current_user.services : []
  end
end
