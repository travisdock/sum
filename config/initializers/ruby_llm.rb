# Configure RubyLLM for voice entry processing with Google Gemini
RubyLLM.configure do |config|
  # Set the Gemini API key from Rails credentials
  # To add the API key, run: rails credentials:edit
  # Then add:
  #   google:
  #     gemini_api_key: YOUR_API_KEY_HERE
  config.gemini_api_key = Rails.application.credentials.dig(:google, :gemini_api_key)
end
