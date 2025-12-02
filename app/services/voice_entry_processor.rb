class VoiceEntryProcessor
  attr_reader :user, :audio_file

  def initialize(user:, audio_file:)
    @user = user
    @audio_file = audio_file
  end

  def process
    # Create a chat instance with Gemini
    chat = RubyLLM.chat(model: 'gemini-2.0-flash-exp')

    # Ask the question with the audio file
    response = chat.ask(build_system_prompt, with: audio_file.path)

    # Extract text from RubyLLM::Message object
    response_text = if response.respond_to?(:content)
      response.content
    elsif response.respond_to?(:text)
      response.text
    else
      response.to_s
    end

    # Extract JSON from response (in case there's extra text)
    json_match = response_text.match(/\{.*\}/m)
    raise 'No JSON found in response' unless json_match

    data = JSON.parse(json_match[0])

    {
      success: true,
      data: {
        amount: data['amount'],
        category_name: data['category_name'],
        date: data['date'] || Date.today.to_s,
        notes: data['notes']
      },
      transcription: response_text
    }
  rescue => e
    Rails.logger.error "Voice entry processing failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    {
      success: false,
      error: "Failed to process voice recording: #{e.message}",
      transcription: nil
    }
  end

  private

  def build_system_prompt
    categories_list = user.categories.pluck(:name).join(', ')

    <<~PROMPT
      You are a financial entry assistant. Extract transaction information from speech and return as JSON.

      Extract:
      - amount: Dollar amount as a number (e.g., 45 or 45.50)
      - category_name: Category that best matches the description from the available categories
      - date: ONLY if a date is explicitly mentioned. Parse dates like "October 15th" as "2025-10-15", "yesterday", "last Tuesday", etc. If NO date is mentioned, set to null.
      - notes: Any additional context or description

      USER'S AVAILABLE CATEGORIES: #{categories_list}

      Return ONLY a JSON object like:
      {"amount": 45, "category_name": "Groceries", "date": "2025-10-15", "notes": "groceries at Trader Joe's"}

      IMPORTANT: Only include a date if the user explicitly mentions one. If no date is mentioned, use null for the date field.

      If you cannot extract amount or category, set them to null.
    PROMPT
  end
end
