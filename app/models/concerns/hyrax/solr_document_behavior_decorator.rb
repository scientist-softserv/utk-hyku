# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to handle the case for
# when title is a different data type (string vs array)
module Hyrax
  module SolrDocumentBehaviorDecorator
    def title_or_label
      return label if title.blank?

      Array(title).join(', ')
    end
  end
end

Hyrax::SolrDocumentBehavior.prepend(Hyrax::SolrDocumentBehaviorDecorator)
