# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include SharedWorkBehavior

  self.indexer = ImageIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
