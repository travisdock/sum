module Taggable
  extend ActiveSupport::Concern

  included do
    belongs_to :tag, optional: true
    accepts_nested_attributes_for :tag, reject_if: :all_blank, allow_destroy: true

    def autosave_associated_records_for_tag
      return if tag.blank?

      if tag.new_record? && Tag.find_by(name: tag.name).nil?
        tag.save
        self.tag = tag
      elsif tag.marked_for_destruction?
        self.tag = nil
        self.save
      elsif tag.new_record? && Tag.find_by(name: tag.name).present?
        self.tag = Tag.find_by(name: tag.name)
      elsif tag.changed? && tag.name.blank?
        self.tag = nil
        self.save
      elsif tag.changed?
        self.tag = Tag.find_or_create_by(name: tag.name)
      end
    end
  end
end
