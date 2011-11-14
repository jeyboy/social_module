class ServicesController < ApplicationController
  protect_from_forgery :except => [:create]  #OpenID request broke devise session
  before_filter :authenticate_user!, :only => [:destroy, :wall]

  def create
    omniauth = request.env["omniauth.auth"]
    service = Service.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if service
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, service.user)
    elsif current_user
      current_user.services.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth[:credentials][:token], :secret => omniauth[:credentials][:secret])
      flash[:notice] = "Authentication successful."
      redirect_to services_url
    else
      redirect_to :root, :notice => "Authorize"
      #user = User.new
      #user.apply_omniauth(omniauth)
      #if user.save
      #  flash[:notice] = "Signed in successfully."
      #  sign_in_and_redirect(:user, user)
      #else
      #  session[:omniauth] = omniauth.except('extra')
      #  redirect_to new_user_registration_url
      #end
    end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to services_url
  end

  def wall
    @info = current_user.services.where(:provider => params[:service]).first().read
  end
end
