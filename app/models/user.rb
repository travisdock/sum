class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  has_and_belongs_to_many :categories
  has_many :entries
  has_many :recurrables
  before_destroy :remove_data

  def tags
    # was going to use has_many through but it was not working
    tag_ids = entries.pluck(:tag_id).uniq
    Tag.where(id: tag_ids)
  end

  def remove_data
    self.tags.destroy_all
    self.entries.destroy_all
    self.categories.destroy_all
  end
end
