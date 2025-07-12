class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    # Since we can't send emails, we'll just redirect with a notice
    # In a real app with email, you would send the reset link here
    redirect_to new_session_path, notice: "Password reset functionality is not available yet (email sending not configured)."
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
      # For now, since we don't have password reset tokens without email,
      # this will just redirect to login
      redirect_to new_session_path, alert: "Password reset link is invalid or has expired."
    end
end