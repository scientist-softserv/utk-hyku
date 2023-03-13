# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GenericWork`
class GenericWork < ActiveFedora::Base
  include SharedWorkBehavior

  include IiifPrint.model_configuration(
    pdf_splitter_service: IiifPrint::SplitPdfs::PagesToJpgsSplitter,
    pdf_split_child_model: self
  )
  
  self.indexer = GenericWorkIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
