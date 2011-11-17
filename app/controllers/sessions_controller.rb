class SessionsController < Devise::SessionsController
  def destroy
    user = current_user.valid? ? nil : current_user
    super
    user.destroy if user
  end
end