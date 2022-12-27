require "application_system_test_case"

class EntriesTest < ApplicationSystemTestCase
  setup do
    @entry = entries(:one)
  end

  test "visiting the index" do
    visit entries_url
    assert_selector "h1", text: "Entries"
  end

  test "should create entry" do
    visit entries_url
    click_on "New entry"

    fill_in "Amount", with: @entry.amount
    fill_in "Category", with: @entry.category_id
    fill_in "Category name", with: @entry.category_name
    fill_in "Date", with: @entry.date
    check "Income" if @entry.income
    fill_in "Notes", with: @entry.notes
    check "Untracked" if @entry.untracked
    fill_in "User", with: @entry.user_id
    click_on "Create Entry"

    assert_text "Entry was successfully created"
    click_on "Back"
  end

  test "should update Entry" do
    visit entry_url(@entry)
    click_on "Edit this entry", match: :first

    fill_in "Amount", with: @entry.amount
    fill_in "Category", with: @entry.category_id
    fill_in "Category name", with: @entry.category_name
    fill_in "Date", with: @entry.date
    check "Income" if @entry.income
    fill_in "Notes", with: @entry.notes
    check "Untracked" if @entry.untracked
    fill_in "User", with: @entry.user_id
    click_on "Update Entry"

    assert_text "Entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Entry" do
    visit entry_url(@entry)
    click_on "Destroy this entry", match: :first

    assert_text "Entry was successfully destroyed"
  end
end
