class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  has_and_belongs_to_many :categories

  def tags
    tag_ids = Entry.where(user: self).pluck(:tag_id).uniq
    Tag.where(id: tag_ids)
  end
end
