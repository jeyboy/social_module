class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def update
    super
  end

  def create
    super
  end

  private

  def build_resource(*args)
    super
    @user.fullname = params[:fullname] if params[:fullname]
    @user.email = params[:email] if params[:email]
    @user.services.build(params[:provider]) if params[:provider]
  end
end