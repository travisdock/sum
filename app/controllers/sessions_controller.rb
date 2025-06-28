class SessionsController < ApplicationController
  before_action :ensure_logged_out, only: [:new, :create]

  def new
    # Login form
  end

  def create
    @user = User.find_by_credentials(params[:email], params[:password])
    
    if @user
      login(@user)
      redirect_to authenticated_root_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to unauthenticated_root_path
  end

  private

  def ensure_logged_out
    redirect_to authenticated_root_path if logged_in?
  end
end