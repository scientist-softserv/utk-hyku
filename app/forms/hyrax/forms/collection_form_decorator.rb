# frozen_string_literal: true

module Hyrax
  module Forms
    module CollectionFormDecorator
      def secondary_terms
        %i[
          alternative_title
          creator
          contributor
          keyword
          license
          publisher
          date_created
          subject
          language
          identifier
          based_near
          related_url
          resource_type
          date_created_d
          date_issued
          date_issued_d
          extent
          form
          publication_place
          repository
          spatial
          utk_contributor
          utk_creator
          utk_publisher
        ]
      end
    end
  end
end

# adds custom terms to `self.terms`
Hyrax::Forms::CollectionForm.terms += %i[
  date_created_d
  date_issued
  date_issued_d
  extent
  form
  publication_place
  repository
  spatial
  utk_contributor
  utk_creator utk_publisher
]

Hyrax::Forms::CollectionForm.prepend(Hyrax::Forms::CollectionFormDecorator)
