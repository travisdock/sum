class ApplicationController < ActionController::Base
  # Authentication
  before_action :require_login, unless: :public_route?
  
  # Authentication methods
  helper_method :current_user, :logged_in?

  def current_user
    return @current_user if @current_user
    
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
    
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def login(user)
    session[:user_id] = user.id
    user.reset_session_token!
  end

  def logout
    current_user&.reset_session_token!
    session[:user_id] = nil
    @current_user = nil
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to new_session_path
    end
  end

  private

  def public_route?
    # Routes that don't require authentication
    controller_name.in?(['sessions', 'users', 'password_resets']) ||
    (controller_name == 'rails/health') ||
    (controller_name == 'application' && action_name == 'root')
  end
end
