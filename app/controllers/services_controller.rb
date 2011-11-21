class ServicesController < ApplicationController
  before_filter :authenticate_user!, :only => [:destroy, :wall]

  def create
    omniauth = request.env['omniauth.auth']
    service = Service.find_by_provider_and_uid(omniauth[:provider], omniauth[:uid])
    if service
      sign_in_and_redirect(:user, service.user, :notice => "Signed in successfully.")
    elsif current_user
      current_user.services.create!(:provider => omniauth[:provider], :uid => omniauth[:uid], :credentials => omniauth[:credentials])
      redirect_to services_url, :notice => "Authentication successful."
    else
      mail = omniauth[:info][:email] || ""
      user = User.find_by_email(mail)

      if user
        user.services.create!(:provider => omniauth[:provider], :uid => omniauth[:uid], :credentials => omniauth[:credentials])
        sign_in_and_redirect(:user, user)
      else
        redirect_to new_user_registration_path(:fullname => (omniauth[:info][:name] || ''), :email => mail, :provider => {:provider => omniauth[:provider], :uid => omniauth[:uid], :credentials => omniauth[:credentials]})
      end
    end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy
    redirect_to services_url, :notice => "Successfully destroyed authentication."
  end

  def wall
    @items = current_user.services.where(:provider => params[:service]).first().read
  end
end
