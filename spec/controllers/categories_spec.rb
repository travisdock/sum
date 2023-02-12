require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    it "returns http success" do
      user = User.create!(email: "test1@mail.com", password: "123456")
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
