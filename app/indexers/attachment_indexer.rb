# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
class AttachmentIndexer < AppIndexer
  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
  self.model_class = ::Attachment
end
