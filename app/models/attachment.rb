# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
class Attachment < ActiveFedora::Base
  include SharedWorkBehavior
  include IiifPrint.model_configuration

  self.indexer = AttachmentIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # A utility method for determining if a given Attachment is an intermediate file.
  def intermediate_file?
    return false if rdf_type.blank?

    rdf_type.join.downcase.include?(Hyrax::ConditionalDerivativeDecorator::INTERMEDIATE_FILE_TYPE_TEXT)
  end
end
