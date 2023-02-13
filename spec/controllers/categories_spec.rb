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

    it "merges two categories" do
      user = User.create!(email: "test1@mail.com", password: "123456")
      sign_in user
      category1 = Category.create!(name: "Category 1")
      category2 = Category.create!(name: "Category 2")
      entry1 = Entry.create!(date: Date.today, notes: "Entry 1", amount: 100, category: category1, user: user)
      entry2 = Entry.create!(date: Date.today, notes: "Entry 2", amount: 200, category: category2, user: user)
      get :merge_form
      expect(response).to have_http_status(:success)
      post :merge, params: { id: category2.id, merge_with: category1.id }
      expect(response).to redirect_to categories_path
      expect(Entry.where(category_id: category2.id).count).to eq(0)
      expect(Entry.where(category_id: category1.id).count).to eq(2)
      expect(Category.find_by(id: category2.id)).to be_nil
    end
  end
end
