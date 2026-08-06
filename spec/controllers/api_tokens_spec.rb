require 'rails_helper'

RSpec.describe ApiTokensController, type: :controller do
  render_views

  before(:all) do
    @user = User.create!(email_address: 'api-tokens-controller@mail.com', password: '123456')
    @other_user = User.create!(email_address: 'api-tokens-controller-other@mail.com', password: '123456')
  end

  after(:all) do
    @user.destroy
    @other_user.destroy
  end

  describe 'GET #index' do
    it 'only lists the current user\'s tokens' do
      mine = @user.api_tokens.create!(name: 'Mine')
      @other_user.api_tokens.create!(name: 'Theirs')

      sign_in @user
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to include(mine.name)
      expect(response.body).not_to include('Theirs')
    end

    it 'reveals a freshly created plaintext token exactly once' do
      sign_in @user
      post :create, params: { api_token: { name: 'Reveal Token' } }
      expect(response).to redirect_to(api_tokens_path)

      get :index
      expect(response.body).to match(/sum_[0-9a-f]{64}/)

      get :index
      expect(response.body).not_to match(/sum_[0-9a-f]{64}/)
    end
  end

  describe 'POST #create' do
    it 'creates a token with a name and redirects to the index' do
      sign_in @user
      expect {
        post :create, params: { api_token: { name: 'New Token' } }
      }.to change(@user.api_tokens, :count).by(1)

      expect(response).to redirect_to(api_tokens_path)
      expect(flash[:new_token]).to match(/\Asum_[0-9a-f]{64}\z/)
    end

    it 'does not create a token without a name' do
      sign_in @user
      expect {
        post :create, params: { api_token: { name: '' } }
      }.not_to change(ApiToken, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create duplicate tokens when submitted twice with the same name' do
      sign_in @user
      post :create, params: { api_token: { name: 'Double Click' } }
      expect(response).to redirect_to(api_tokens_path)

      expect {
        post :create, params: { api_token: { name: 'Double Click' } }
      }.not_to change(ApiToken, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'gracefully handles a concurrent request that races past validation and hits the DB constraint' do
      sign_in @user
      allow_any_instance_of(ApiToken).to receive(:save).and_raise(ActiveRecord::RecordNotUnique)

      expect {
        post :create, params: { api_token: { name: 'Race Condition' } }
      }.not_to change(ApiToken, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('has already been taken')
    end
  end

  describe 'DELETE #destroy' do
    it "deletes the current user's token" do
      token = @user.api_tokens.create!(name: 'To delete')
      sign_in @user

      expect {
        delete :destroy, params: { id: token.id }
      }.to change(ApiToken, :count).by(-1)

      expect(response).to redirect_to api_tokens_path
    end

    it "cannot delete another user's token" do
      token = @other_user.api_tokens.create!(name: 'Not mine')
      sign_in @user

      expect {
        delete :destroy, params: { id: token.id }
      }.not_to change(ApiToken, :count)

      expect(response).to redirect_to api_tokens_path
    end
  end
end
