module Authentication
  extend ActiveSupport::Concern
  
  included do
    helper_method :current_user, :user_signed_in?
  end
  
  private
  
  def authenticate_user!
    unless user_signed_in?
      store_location
      redirect_to login_path, alert: "You need to sign in or sign up before continuing."
    end
  end
  
  def current_user
    @current_user ||= find_current_user
  end
  
  def user_signed_in?
    current_user.present?
  end
  
  def sign_in(user, remember_me: false)
    reset_session # Prevent session fixation
    session[:user_id] = user.id
    session[:expires_at] = 1.month.from_now.iso8601
    
    if remember_me
      user.remember_me!
      cookies.permanent.signed[:remember_token] = {
        value: user.id,
        httponly: true,
        secure: Rails.env.production?
      }
    end
    
    @current_user = user
  end
  
  def sign_out
    if current_user&.remember_created_at.present?
      current_user.forget_me!
    end
    
    reset_session
    cookies.delete(:remember_token)
    @current_user = nil
  end
  
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
  
  def redirect_back_or(default)
    redirect_to(session.delete(:return_to) || default)
  end
  
  private
  
  def find_current_user
    # Check if session is expired
    if session[:expires_at].present? && Time.parse(session[:expires_at]) < Time.current
      reset_session
      return nil
    end
    
    # Try to find user from session
    if session[:user_id].present?
      user = User.find_by(id: session[:user_id])
      if user
        # Extend session timeout on activity
        session[:expires_at] = 1.month.from_now.iso8601
        return user
      end
    end
    
    # Try to find user from remember me cookie
    if cookies.signed[:remember_token].present?
      user = User.find_by(id: cookies.signed[:remember_token])
      if user&.remember_me?
        sign_in(user)
        return user
      else
        cookies.delete(:remember_token)
      end
    end
    
    nil
  end
end