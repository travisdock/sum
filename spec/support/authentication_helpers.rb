module AuthenticationHelpers
  def sign_in(user)
    if respond_to?(:session)
      # For controller specs
      session[:user_id] = user.id
      session[:expires_at] = 1.month.from_now.iso8601
    else
      # For request/system specs
      post login_path, params: { email: user.email, password: user.password }
    end
  end
  
  def sign_out
    if respond_to?(:session)
      session.delete(:user_id)
      session.delete(:expires_at)
    else
      delete logout_path
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
  config.include AuthenticationHelpers, type: :request
  config.include AuthenticationHelpers, type: :system
end