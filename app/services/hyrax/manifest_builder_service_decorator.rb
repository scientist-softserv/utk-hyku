# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to use IIIF Presentation API V3
module Hyrax
  module ManifestBuilderServiceDecorator
    def self.manifest_for(presenter:, iiif_manifest_factory: ::IIIFManifest::V3::ManifestFactory)
      new(iiif_manifest_factory: iiif_manifest_factory)
        .manifest_for(presenter: presenter)
    end

    def initialize(iiif_manifest_factory: ::IIIFManifest::V3::ManifestFactory)
      @manifest_factory = iiif_manifest_factory
    end
  end
end

Hyrax::ManifestBuilderService.prepend(Hyrax::ManifestBuilderServiceDecorator)
