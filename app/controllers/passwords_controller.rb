class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      # Since we're not using mailers, we'll store the reset link in the session
      # In a real application without email, you might display this to the user or use SMS
      reset_url = edit_password_url(user.password_reset_token)
      Rails.logger.info "Password reset URL for #{user.email_address}: #{reset_url}"
      flash[:notice] = "Password reset instructions sent (check logs for reset URL in development)."
    else
      flash[:notice] = "Password reset instructions sent (if user with that email address exists)."
    end
    
    redirect_to new_session_path
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end