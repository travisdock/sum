require "rails_helper"

RSpec.describe EntriesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    before(:all) do
      @user = User.create!(email: "test@mail.com", password: "12345678")
      @category = Category.create!(name: "Category 1")
    end

    after(:all) do
      @user.destroy
      @category.destroy
    end

    it "returns http success" do
      sign_in @user
      get :new
      expect(response).to have_http_status(:success)
    end

    it "creates an entry with no tag" do
      sign_in @user
      expect {
        post :create, params: { entry: { category_id: @category.id, amount: 100, date: Date.today, notes: "Test", tag_attributes: { name: '' } } }
      }.to change(Entry, :count).by(1)
       .and change(Tag, :count).by(0)
      expect(response).to redirect_to new_entry_path
    end

    it "creates an entry with a new tag" do
      sign_in @user
      expect {
        post :create, params: { entry: { category_id: @category.id, amount: 100, date: Date.today, notes: "Test", tag_attributes: { name: 'test' } } }
      }.to change(Entry, :count).by(1)
       .and change(Tag, :count).by(1)
      expect(Entry.last.tag.name).to eq('test')
      expect(Entry.last.category.name).to eq(@category.name)
      expect(response).to redirect_to new_entry_path
    end

    it "creates an entry with an existing tag" do
      sign_in @user
      tag = Tag.create!(name: "test")
      expect {
        post :create, params: { entry: { category_id: @category.id, amount: 100, date: Date.today, notes: "Test", tag_attributes: { name: tag.name } } }
      }.to change(Entry, :count).by(1)
       .and change(Tag, :count).by(0)
      expect(Entry.last.tag).to eq(tag)
      expect(response).to redirect_to new_entry_path
    end

    it "updates an entry with no tag" do
      sign_in @user
      entry = Entry.create!(category_id: @category.id, amount: 100, date: Date.today, notes: "Test", user_id: @user.id)
      expect {
        patch :update, params: { id: entry.id, entry: { category_id: @category.id, amount: 200, date: Date.today, notes: "Test", tag_attributes: { name: '' } } }
      }.to change(Entry, :count).by(0)
       .and change(Tag, :count).by(0)
      expect(Entry.last.amount).to eq(200)
      expect(response).to redirect_to entry_path(entry)
    end

    it "updates an entry and not the existing tag" do
      sign_in @user
      tag = Tag.create!(name: "test")
      entry = Entry.create!(category_id: @category.id, amount: 100, date: Date.today, notes: "Test", user_id: @user.id, tag: tag)
      expect {
        patch :update, params: { id: entry.id, entry: { category_id: @category.id, amount: 200, date: Date.today, notes: "Test", tag_attributes: { name: tag.name } } }
      }.to change(Entry, :count).by(0)
       .and change(Tag, :count).by(0)
      expect(Entry.last.amount).to eq(200)
      expect(Entry.last.tag).to eq(tag)
      expect(response).to redirect_to entry_path(entry)
    end

    it "updates an entry and removes the existing tag without destroying it" do
      sign_in @user
      tag = Tag.create!(name: "test")
      entry = Entry.create!(category_id: @category.id, amount: 100, date: Date.today, notes: "Test", user_id: @user.id, tag: tag)
      expect {
patch :update, params: { id: entry.id, entry: { category_id: @category.id, amount: 200, date: Date.today, notes: "Test", tag_attributes: { id: tag.id, name: tag.name, _destroy: 1 } } }
      }.to change(Entry, :count).by(0)
       .and change(Tag, :count).by(0)
      expect(Entry.last.amount).to eq(200)
      expect(Entry.last.tag).to eq(nil)
      expect(response).to redirect_to entry_path(entry)
    end
  end
end
