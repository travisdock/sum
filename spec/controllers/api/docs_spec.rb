require 'rails_helper'

RSpec.describe Api::DocsController, type: :controller do
  describe 'GET #show' do
    it 'returns the api docs markdown without requiring authentication' do
      get :show

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq('text/markdown')
      expect(response.body).to include('POST /api/entries')
    end
  end
end
