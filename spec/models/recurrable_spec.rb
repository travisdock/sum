require 'rails_helper'

RSpec.describe Recurrable, type: :model do
  describe "overwriting day_of_month" do
    it "should set schedule and schedule_string" do
      day_of_month = 1
      recurrable = Recurrable.new(day_of_month: day_of_month)
      expect(recurrable.schedule.next_occurrence).to eq(Date.today.next_month.beginning_of_month)
      expect(recurrable.schedule_string).to eq("Monthly on the 1st day of the month")
    end
  end

  describe "#create_occurence" do
    it "should create an occurence" do
      category = Category.create(name: "Test")
      user = User.create(email: "test@mail.com", password: "password")
      recurrable = Recurrable.create(name: "Test", category: category, user: user, day_of_month: 1, notes: "test notes", amount: 100)

      expect { recurrable.create_occurrence }.to change { Entry.count }.by(1)
      expect(Entry.last.amount).to eq(100)
      expect(Entry.last.notes).to eq("test notes")
      expect(Entry.last.category).to eq(category)
      expect(Entry.last.user).to eq(user)
    end
  end
end
