class ApiTokensController < ApplicationController
  before_action :set_api_token, only: [:destroy]

  # GET /api_tokens
  def index
    @api_tokens = current_user.api_tokens.order(created_at: :desc)
    @new_token = flash[:new_token]
    flash.delete(:new_token)
  end

  # GET /api_tokens/new
  def new
    @api_token = ApiToken.new
  end

  # POST /api_tokens
  def create
    @api_token = current_user.api_tokens.new(api_token_params)

    if @api_token.save
      flash[:new_token] = @api_token.plaintext_token
      redirect_to api_tokens_url, notice: 'API token created.'
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @api_token.errors.add(:name, :taken)
    render :new, status: :unprocessable_entity
  end

  # DELETE /api_tokens/1
  def destroy
    @api_token.destroy
    redirect_to api_tokens_url, notice: 'API token deleted.'
  end

  private

  def set_api_token
    @api_token = current_user.api_tokens.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to api_tokens_url, alert: 'API token not found.'
  end

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
