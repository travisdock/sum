class SessionsController < ApplicationController
  
  def new
    redirect_to root_path if user_signed_in?
  end
  
  def create
    user = User.find_by(email: params[:email]&.downcase)
    
    if user&.authenticate(params[:password])
      sign_in(user, remember_me: params[:remember_me] == "1")
      redirect_back_or(root_path)
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    sign_out
    redirect_to login_path, notice: "You have been signed out successfully."
  end
end