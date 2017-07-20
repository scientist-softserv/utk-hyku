module HasRendering
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Rails/HasAndBelongsToMany
    # dc:hasFormat defined in Presentation API context:  http://iiif.io/api/presentation/2/context.json
    has_and_belongs_to_many :renderings,
                            predicate: ::RDF::Vocab::DC.hasFormat,
                            class_name: 'ActiveFedora::Base'
    # rubocop:enable Rails/HasAndBelongsToMany
  end
end
