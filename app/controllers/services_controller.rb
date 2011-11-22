class ServicesController < ApplicationController
  before_filter :authenticate_user!, :only => [:destroy, :wall]

  def create
    omniauth = request.env['omniauth.auth']
    if service = Service.find_by_provider_and_uid(omniauth[:provider], omniauth[:uid])
      sign_in_and_redirect(:user, service.user, :notice => "Signed in successfully.")
    elsif current_user
      current_user.services.create(:provider => omniauth[:provider], :uid => omniauth[:uid], :credentials => omniauth[:credentials])
      redirect_to services_url, :notice => "Authentication successful."
    else
      mail = omniauth[:info][:email]

      if user = User.find_by_email(mail)
        user.services.create(:provider => omniauth[:provider], :uid => omniauth[:uid], :credentials => omniauth[:credentials])
        sign_in_and_redirect(:user, user)
      else
        redirect_to new_user_registration_path(
                        :fullname => (omniauth[:info][:name].to_s),
                        :email => mail,
                        :provider => {:provider => omniauth[:provider], :uid => omniauth[:uid],
                            :credentials => omniauth[:credentials]
                        })
      end
    end
  end

  def destroy
    if user = current_user.services.find_by_id(params[:id])
      user.destroy
      mess = "Successfully destroyed authentication."
    else
      mess = "Destroying of the authentication is failed."
    end

    redirect_to services_url, :notice => mess
  end

  def wall
    obj = current_user.services.for_provider(params[:service]).first
    @items = obj.respond_to?(:read) ? obj.read : []
  end

  def failure
    redirect_to :root
  end
end
