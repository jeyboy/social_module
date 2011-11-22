class RegistrationsController < Devise::RegistrationsController
  private
  def build_resource(*args)
    if params[:user] and params[:user][:services_attributes] and params[:user][:services_attributes]['0']
      begin
        params[:user][:services_attributes]['0'][:credentials] = Hash.from_xml(params[:user][:services_attributes]['0'][:credentials])['hash']
      rescue
        params[:user][:services_attributes]['0'][:credentials] = nil
      end
    end

    super

    @user.fullname = params[:fullname] if params[:fullname]
    @user.email = params[:email] if params[:email]

    if params[:provider]
      params[:provider][:credentials] = params[:provider][:credentials]
      @user.services.build(params[:provider])
    end

    @user.services.first.credentials = @user.services.first.credentials.to_xml if @user.services.first and !@user.valid?
  end
end