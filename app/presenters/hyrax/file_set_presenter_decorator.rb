# frozen_string_literal: true

module Hyrax
  module FileSetPresenterDecorator
    delegate :intermediate_file?, to: :solr_document
  end
end

Hyrax::FileSetPresenter.prepend(Hyrax::FileSetPresenterDecorator)
