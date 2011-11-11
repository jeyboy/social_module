class ServicesController < ApplicationController
#  before_filter :authenticate_user!, :except => [:create]
#
#  def index
#    # get all authentication services assigned to the current user
#    @services = current_user.services.all
#  end
#
#  def destroy
#    # remove an authentication service linked to the current user
#    @service = current_user.services.find(params[:id])
#    @service.destroy
#
#    redirect_to services_path
#  end
#
#  def create
#    omniauth = request.env['omniauth.auth'] # get the full hash from omniauth
#
#    if omniauth and params[:service]
#      # map the returned hashes to our variables first - the hashes differ for every service
#      if params[:service] == 'facebook'
#        email =  omniauth['extra']['user_hash']['email'] || ''
#        name =  omniauth['extra']['user_hash']['name'] || ''
#        uid =  omniauth['extra']['user_hash']['id'] || ''
#        provider =  omniauth['provider'] || ''
#      elsif params[:service] == 'github'
#        email =  omniauth['user_info']['email'] || ''
#        name =  omniauth['user_info']['name'] || ''
#        uid =  omniauth['extra']['user_hash']['id'] || ''
#        provider =  omniauth['provider'] || ''
#      elsif params[:service] == 'twitter'
#        email = ''    # Twitter API never returns the email address
#        name =  omniauth['info']['name'] || ''
#        uid =  omniauth['uid'] || ''
#        provider =  omniauth['provider'] || ''
#      elsif params[:service] == 'google'
#        email =  omniauth['user_info']['email'] || ''
#        name =  omniauth['user_info']['name'] || ''
#        uid =  omniauth['uid'] || ''
#        provider = omniauth['provider'] || ''
#      else
#        # we have an unrecognized service, just output the hash that has been returned
#        render :text => omniauth.to_yaml and return
#      end
#
#      # continue only if provider and uid exist
#      if uid != '' and provider != '' # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
#        if !user_signed_in?           # check if user has already signed in using this service provider and continue with sign in process if yes
#          auth = Service.find_by_provider_and_uid(provider, uid)
#          if auth
#            sign_in_and_redirect :user, auth.user, :notice => 'Signed in successfully via ' + provider.capitalize + '.'
#          else # check if this user is already registered with this email address; get out if no email has been provided
#            if email != '' # search for a user with this email address
#              existing_user = User.find_by_email(email)
#              if existing_user # map this new login method via a service provider to an existing account if the email address is the same
#                existing_user.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
#                sign_in_and_redirect(:user, existinguser, :notice => 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existing_user.email + '. Signed in successfully!')
#              else # let's create a new user: register this user and add this authentication method for this user
#                name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us
#                # new user, set email, a random password and take the name from the authentication service
#                user = User.new :email => email, :password => SecureRandom.hex(10), :fullname => name
#                user.services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)
#
#                # do not send confirmation email, we directly save and confirm the new record
#                #user.skip_confirmation!
#                user.save!
#                #user.confirm!
#
#                sign_in_and_redirect(:user, user, :notice => 'Your account on CommunityGuides has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.')
#              end
#            else
#              redirect_to new_user_session_path, :error => params[:service].capitalize + ' can not be used to sign-up on CommunityGuides as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + params[:service].capitalize + ' from your profile.'
#            end
#          end
#        else # the user is currently signed in
#          auth = Service.find_by_provider_and_uid(provider, uid)
#          if !auth
#            current_user.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
#            redirect_to services_path, :notice => 'Sign in via ' + provider.capitalize + ' has been added to your account.'
#          else
#            redirect_to services_path, :notice => params[:service].capitalize + ' is already linked to your account.'
#          end
#        end
#      else
#        redirect_to new_user_session_path, :error => params[:service].capitalize + ' returned invalid data for the user id.'
#      end
#    else
#      redirect_to new_user_session_path, :error => 'Global error.'
#    end
#  end

  def index
    @services = current_user.services if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    service = Service.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if service
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, service.user)
    elsif current_user
      current_user.services.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to services_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to services_url
  end
end
