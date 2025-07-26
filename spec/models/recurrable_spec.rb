require 'rails_helper'

RSpec.describe Recurrable, type: :model do
  describe '#create_occurence' do
    it 'should create an occurence' do
      category = Category.create(name: 'Test')
      user = User.create(email_address: 'test@mail.com', password: 'password')
      recurrable = Recurrable.create(name: 'Test', category: category, user: user, day_of_month: 1,
                                     notes: 'test notes', amount: 100)

      expect { recurrable.create_occurrence }.to change { Entry.count }.by(1)
      expect(Entry.last.amount).to eq(100)
      expect(Entry.last.notes).to eq('test notes')
      expect(Entry.last.category).to eq(category)
      expect(Entry.last.user).to eq(user)
    end
  end
end
