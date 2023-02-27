require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    before(:all) do
      @user = User.create!(email: "test@mail.com", password: "123456")
      @category1 = Category.create!(name: "Test Category 1")
      @category2 = Category.create!(name: "Test Category 2")
      @user.categories << @category1
      @user.categories << @category2
    end

    after(:all) do
      @user.destroy
      @category1.destroy
      @category2.destroy
    end

    it "returns http success" do
      sign_in @user
      get :index
      expect(response).to have_http_status(:success)
    end

    it "merges two categories with no tag" do
      sign_in @user
      entry1 = Entry.create!(date: Date.today, notes: "Entry 1", amount: 100, category: @category1, user: @user)
      entry2 = Entry.create!(date: Date.today, notes: "Entry 2", amount: 200, category: @category2, user: @user)
      get :merge_form
      expect(response).to have_http_status(:success)
      post :merge, params: { id: @category2.id, merge_with: @category1.id }
      expect(response).to redirect_to merge_categories_path
      expect(Entry.where(category_id: @category2.id).count).to eq(0)
      expect(Entry.where(category_id: @category1.id).count).to eq(2)
      expect(Category.find_by(id: @category2.id)).to be_nil
    end

    it "merges two categories with new tag" do
      sign_in @user
      entry1 = Entry.create!(date: Date.today, notes: "Entry 1", amount: 100, category: @category1, user: @user)
      entry2 = Entry.create!(date: Date.today, notes: "Entry 2", amount: 200, category: @category2, user: @user)
      get :merge_form
      expect(response).to have_http_status(:success)
      post :merge, params: { id: @category2.id, merge_with: @category1.id, tag_name: "Test Tag" }
      expect(response).to redirect_to merge_categories_path
      expect(Entry.where(category_id: @category2.id).count).to eq(0)
      expect(Entry.where(category_id: @category1.id).count).to eq(2)
      expect(Category.find_by(id: @category2.id)).to be_nil
      expect(entry2.reload.tag.name).to eq("Test Tag")
      expect(Entry.where(tag_id: entry2.tag.id).count).to eq(1)
    end

    it "merges two categories with existing tag" do
      sign_in @user
      entry1 = Entry.create!(date: Date.today, notes: "Entry 1", amount: 100, category: @category1, user: @user)
      entry2 = Entry.create!(date: Date.today, notes: "Entry 2", amount: 200, category: @category2, user: @user)
      tag = Tag.create!(name: "Test Tag")
      entry3 = Entry.create!(date: Date.today, notes: "Entry 3", amount: 300, category: @category2, user: @user, tag: tag)

      get :merge_form
      expect(response).to have_http_status(:success)
      post :merge, params: { id: @category2.id, merge_with: @category1.id, tag_id: tag.id }
      expect(response).to redirect_to merge_categories_path
      expect(Entry.where(category_id: @category2.id).count).to eq(0)
      expect(Entry.where(category_id: @category1.id).count).to eq(3)
      expect(Category.find_by(id: @category2.id)).to be_nil
      expect(entry2.reload.tag.name).to eq("Test Tag")
      expect(Entry.where(tag_id: entry2.tag.id).count).to eq(2)
    end
  end
end
