class VoiceEntriesController < ApplicationController
  # Rate limiting: 5 requests per minute per user
  before_action :check_voice_entries_access
  before_action :check_rate_limit

  def create
    validate_audio!

    processor = VoiceEntryProcessor.new(
      user: current_user,
      audio_file: params[:audio_file].tempfile
    )

    result = processor.process

    if result[:success]
      render json: result
    else
      render json: result, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Voice entry creation failed: #{e.message}"
    render json: {
      success: false,
      error: e.message,
      transcription: nil
    }, status: :unprocessable_entity
  end

  private

  def check_voice_entries_access
    unless current_user.voice_entries_enabled?
      render json: {
        success: false,
        error: 'Voice entries feature is not enabled for your account.',
        transcription: nil
      }, status: :forbidden
    end
  end

  def validate_audio!
    audio = params[:audio_file]

    raise 'No audio file provided' unless audio.present?

    # Check content type
    unless audio.content_type&.start_with?('audio/')
      raise 'Invalid file type. Must be audio file.'
    end

    # Check file size (max 5MB)
    if audio.size > 5.megabytes
      raise 'Audio file too large. Maximum size is 5MB.'
    end
  end

  def check_rate_limit
    cache_key = "voice_entries:#{current_user.id}:#{Time.current.to_i / 60}"
    count = Rails.cache.read(cache_key) || 0

    if count >= 5
      render json: {
        success: false,
        error: 'Too many requests. Please wait a moment.',
        transcription: nil
      }, status: :too_many_requests
      return
    end

    Rails.cache.write(cache_key, count + 1, expires_in: 1.minute)
  end
end
