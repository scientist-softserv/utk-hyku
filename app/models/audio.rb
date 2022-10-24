# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Audio`
class Audio < ActiveFedora::Base
  include SharedWorkBehavior

  self.indexer = AudioIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
