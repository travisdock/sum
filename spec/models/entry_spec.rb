require "rails_helper"

RSpec.describe Entry, type: :model do
  describe "scopes" do
    it "should return only entries from the given year" do
      user = User.create!(email: "test1@mail.com", password: "123456")
      category = Category.create!(name: "Category 1")
      entry1 = Entry.create!(date: Date.new(2015, 1, 1), user: user, category: category, amount: 100)
      entry2 = Entry.create!(date: Date.new(2015, 2, 1), user: user, category: category, amount: 100)
      entry3 = Entry.create!(date: Date.new(2014, 1, 1), user: user, category: category, amount: 100)

      expect(Entry.by_year(2015)).to include(entry1, entry2)
      expect(Entry.by_year(2015)).to_not include(entry3)
    end

    it "should return only entries from the given month" do
      user = User.create!(email: "test1@mail.com", password: "123456")
      category = Category.create!(name: "Category 1")
      entry1 = Entry.create!(date: Date.new(2015, 2, 1), user: user, category: category, amount: 100)
      entry2 = Entry.create!(date: Date.new(2015, 2, 1), user: user, category: category, amount: 100)
      entry3 = Entry.create!(date: Date.new(2015, 1, 1), user: user, category: category, amount: 100)

      expect(Entry.by_month(2)).to include(entry1, entry2)
      expect(Entry.by_month(2)).to_not include(entry3)
    end

    it "should return only non-income entries" do
      user = User.create!(email: "test1@mail.com", password: "123456")
      category1 = Category.create!(name: "Category 1", income: true)
      category2 = Category.create!(name: "Category 2", income: false)
      entry1 = Entry.create!(date: Date.today, user: user, category: category2, amount: 100)
      entry2 = Entry.create!(date: Date.today, user: user, category: category2, amount: 100)
      entry3 = Entry.create!(date: Date.today, user: user, category: category1, amount: 100)

      expect(Entry.by_income(false)).to include(entry1, entry2)
      expect(Entry.by_income(false)).to_not include(entry3)
    end
  end
end
