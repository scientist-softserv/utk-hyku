# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
class Attachment < ActiveFedora::Base
  include SharedWorkBehavior
  include IiifPrint.model_configuration(
    pdf_splitter_service: IiifPrint::SplitPdfs::PagesToJpgsSplitter,
    pdf_split_child_model: self,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )

  self.indexer = AttachmentIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
