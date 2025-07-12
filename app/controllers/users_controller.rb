class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  before_action :set_user, only: [:edit, :update]
  
  def new
    redirect_to root_path if authenticated?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: "Welcome! You have signed up successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    # Allow updating without providing current password
    if @user.update(user_update_params)
      redirect_to edit_user_path(@user), notice: "Your account has been updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_user
    @user = Current.user
  end
  
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
  
  def user_update_params
    # Only permit password fields if they are present
    permitted = [:email_address]
    if params[:user][:password].present?
      permitted += [:password, :password_confirmation]
    end
    params.require(:user).permit(permitted)
  end
end