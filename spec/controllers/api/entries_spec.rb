require 'rails_helper'

RSpec.describe Api::EntriesController, type: :controller do
  before(:all) do
    @user = User.create!(email_address: 'api-entries-controller@mail.com', password: '123456')
    @category = Category.create!(name: 'Groceries')
    @user.categories << @category
  end

  after(:all) do
    @user.destroy
    @category.destroy
  end

  let(:api_token) { @user.api_tokens.create!(name: 'Test Token') }

  def authenticate!(token)
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'POST #create' do
    it 'creates an entry using category_id' do
      authenticate!(api_token.plaintext_token)
      expect {
        post :create, params: { amount: 12.34, date: Date.today, notes: 'Coffee', category_id: @category.id }
      }.to change(Entry, :count).by(1)

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['entry']['category']['id']).to eq(@category.id)
    end

    it 'creates an entry using category_name' do
      authenticate!(api_token.plaintext_token)
      expect {
        post :create, params: { amount: 12.34, category_name: @category.name }
      }.to change(Entry, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'defaults date to today when omitted' do
      authenticate!(api_token.plaintext_token)
      post :create, params: { amount: 12.34, category_id: @category.id }

      expect(response.parsed_body['entry']['date']).to eq(Date.current.to_s)
      expect(Entry.last.date).to eq(Date.current)
    end

    it 'defaults date to today when sent as a blank string' do
      authenticate!(api_token.plaintext_token)
      post :create, params: { amount: 12.34, category_id: @category.id, date: '' }

      expect(response.parsed_body['entry']['date']).to eq(Date.current.to_s)
      expect(Entry.last.date).to eq(Date.current)
    end

    it 'creates an entry with a tag_name, finding or creating the tag' do
      authenticate!(api_token.plaintext_token)
      expect {
        post :create, params: { amount: 12.34, category_id: @category.id, tag_name: 'reimbursable' }
      }.to change(Entry, :count).by(1).and change(Tag, :count).by(1)

      expect(Entry.last.tag.name).to eq('reimbursable')
    end

    it 'returns a 422 with available_categories for an unmatched category_name' do
      authenticate!(api_token.plaintext_token)
      post :create, params: { amount: 12.34, category_name: 'Nonexistent' }

      expect(response).to have_http_status(:unprocessable_entity)
      body = response.parsed_body
      expect(body['error']).to eq('category_not_found')
      expect(body['available_categories']).to include(@category.name)
    end

    it 'returns a 422 when neither category_id nor category_name is provided' do
      authenticate!(api_token.plaintext_token)
      post :create, params: { amount: 12.34 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['error']).to eq('category_not_found')
    end

    it 'returns a 401 when the Authorization header is missing' do
      post :create, params: { amount: 12.34, category_id: @category.id }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a 401 for an unknown token' do
      authenticate!('sum_bogus')
      post :create, params: { amount: 12.34, category_id: @category.id }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'records usage on the token for a successful request' do
      token = api_token
      authenticate!(token.plaintext_token)
      expect {
        post :create, params: { amount: 12.34, category_id: @category.id }
      }.to change { token.reload.request_count }.from(0).to(1)
      expect(token.last_used_at).to be_present
    end
  end
end
