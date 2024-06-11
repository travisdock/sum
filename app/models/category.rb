class Category < ApplicationRecord
  has_and_belongs_to_many :users

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
