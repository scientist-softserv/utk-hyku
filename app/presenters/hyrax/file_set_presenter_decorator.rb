# frozen_string_literal: true

# OVERRIDE Hyrax v3.5.0 to utilize a utility method to determine if the file is an intermediate file

module Hyrax
  module FileSetPresenterDecorator
    delegate :intermediate_file?, to: :solr_document
  end
end

Hyrax::FileSetPresenter.prepend(Hyrax::FileSetPresenterDecorator)
