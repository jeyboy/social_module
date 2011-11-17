class ServicesController < ApplicationController
  #protect_from_forgery :except => [:create]  #OpenID request broke devise session
  before_filter :authenticate_user!, :only => [:destroy, :wall]

  def create
    omniauth = request.env["omniauth.auth"]
    service = Service.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if service
      sign_in_and_redirect(:user, service.user, :notice => "Signed in successfully.")
    elsif current_user
      current_user.services.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :credentials => omniauth[:credentials])
      redirect_to services_url, :notice => "Authentication successful."
    else
      mail = omniauth['info']['email'] || ""

      user = User.find_by_email(mail)
      if user
        #user.valid_fullname?(name)
        user.services.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :credentials => omniauth[:credentials])
        sign_in_and_redirect(:user, user)
      else
        def_pass = '0000'
        user = User.new({:fullname => (omniauth['info']['name'] || ""), :email => mail, :password => def_pass, :password_confirmation => def_pass})
        user.save(:validate => false)
        user.services.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :credentials => omniauth[:credentials])
        sign_in(:user, user)
        redirect_to edit_user_registration_path, :notice => "Pasword by default equal #{def_pass}"
      end



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
    @items = current_user.services.where(:provider => params[:service]).first().read
  end
end
