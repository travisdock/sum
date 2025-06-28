class PasswordResetsController < ApplicationController
  before_action :find_user_by_token, only: [:show, :update]

  def new
    # Password reset request form
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    
    if @user
      @user.generate_password_reset_token!
      # In a real app, you'd send an email here
      # PasswordResetMailer.reset_password(@user).deliver_now
      flash[:notice] = "Password reset instructions have been sent to your email."
    else
      flash[:notice] = "If an account with that email exists, password reset instructions have been sent."
    end
    
    redirect_to new_session_path
  end

  def show
    # Password reset form
  end

  def update
    if @user.password_reset_expired?
      flash[:alert] = "Password reset token has expired. Please request a new one."
      redirect_to new_password_reset_path
    elsif @user.update(password_params)
      @user.update(password_reset_token: nil, password_reset_sent_at: nil)
      login(@user)
      flash[:notice] = "Password has been reset successfully."
      redirect_to authenticated_root_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def find_user_by_token
    @user = User.find_by(password_reset_token: params[:token])
    
    unless @user
      flash[:alert] = "Invalid password reset token."
      redirect_to new_password_reset_path
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end