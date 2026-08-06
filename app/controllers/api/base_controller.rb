module Api
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_api_token!

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    private

    def current_user
      @current_api_token&.user
    end

    def authenticate_api_token!
      @current_api_token = authenticate_with_http_token { |token, _options| ApiToken.authenticate(token) }
      render_unauthorized unless @current_api_token
    end

    def render_unauthorized
      response.set_header('WWW-Authenticate', 'Bearer realm="Sum API"')
      render json: {
        error: 'unauthorized',
        message: 'Invalid or missing API token. Send it as `Authorization: Bearer <token>`.'
      }, status: :unauthorized
    end

    def render_not_found
      render json: { error: 'not_found', message: 'Record not found.' }, status: :not_found
    end
  end
end
