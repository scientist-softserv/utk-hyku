# frozen_string_literal: true

class ReindexItemJob < ApplicationJob
  def perform(item_id)
    item = ActiveFedora::Base.find(item_id)
    item.update_index
  end
end
