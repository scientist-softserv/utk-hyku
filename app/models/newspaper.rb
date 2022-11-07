# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Newspaper`
class Newspaper < ActiveFedora::Base
  include SharedWorkBehavior

  self.indexer = NewspaperIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
