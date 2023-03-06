class Recurrable < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :tag, optional: true
end
