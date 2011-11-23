class RegistrationsController < Devise::RegistrationsController
  private
  def build_resource(*args)
    super

    @user.fullname = params[:fullname] if params[:fullname]
    @user.email = params[:email] if params[:email]
    if params[:provider]
      params[:provider][:credentials] = params[:provider][:credentials].to_xml
      @user.services.build(params[:provider])
    end
  end
end