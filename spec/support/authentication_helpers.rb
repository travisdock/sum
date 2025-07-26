module AuthenticationHelpers
  def sign_in(user)
    if respond_to?(:cookies)
      # For controller specs - create a session and set cookie
      session_record = user.sessions.create!(
        user_agent: 'RSpec Test',
        ip_address: '127.0.0.1'
      )
      cookies.signed[:session_id] = { value: session_record.id, httponly: true }
    else
      # For request/system specs
      post session_path, params: { email_address: user.email_address, password: user.password }
    end
  end

  def sign_out
    if respond_to?(:cookies)
      if session_id = cookies.signed[:session_id]
        Session.find_by(id: session_id)&.destroy
      end
      cookies.delete(:session_id)
    else
      delete session_path
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
  config.include AuthenticationHelpers, type: :request
  config.include AuthenticationHelpers, type: :system
end
