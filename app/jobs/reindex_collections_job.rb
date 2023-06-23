# frozen_string_literal: true

class ReindexCollectionsJob < ApplicationJob
  def perform(collection_id: nil)
    if collection_id
      Collection.find(collection_id).update_index
    else
      Collection.find_each do |collection|
        collection.reindex_extent = Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
        collection.update_index
      end
    end
  end
end
