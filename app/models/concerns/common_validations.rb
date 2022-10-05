# frozen_string_literal: true

module CommonValidations
  extend ActiveSupport::Concern
  included do
    validate :title_count

    def title_count
      if title.blank?
        errors.add :base, 'Your work must have a title.'
      elsif title.is_a? ActiveTriples::Relation
        errors.add :base, 'Your work can only have one title.' if title.length > 1
      end
    end
  end
end
