# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to use IIIF Presentation API V3
module Hyrax
  module ManifestBuilderServiceDecorator
    module ClassMethods
      def manifest_for(iiif_manifest_factory: ::IIIFManifest::V3::ManifestFactory, presenter:)
        new(iiif_manifest_factory: iiif_manifest_factory)
          .manifest_for(presenter: presenter)
      end
    end

    # def initialize(iiif_manifest_factory: ::IIIFManifest::V3::ManifestFactory)
    #   @manifest_factory = iiif_manifest_factory
    # end

    private

      def build_manifest(presenter:)
        # OVERRIDE IiifPrint v1.0.0 
        # ::IIIFManifest::ManifestBuilder#to_h returns a
        # IIIFManifest::ManifestBuilder::IIIFManifest, not a Hash.
        # to get a Hash, we have to call its #to_json, then parse.
        #
        # wild times. maybe there's a better way to do this with the
        # ManifestFactory interface?
        manifest = iiif_manifest_factory_for(@version).new(presenter).to_h
        hash = JSON.parse(manifest.to_json)
        hash.delete('rendering') # removes rendering since UTK does not use this property on the base manifest
        hash.delete('service') # removes service since UTK does not use this property on the base manifest
        # hash['label'] = sanitize_value(hash['label']) if hash.key?('label')
        hash['provider'] = provider
        # TODO: MAY BE A TEMPORARY IMPLEMENTATION UNTIL #is_part_of IS SET UP
        hash['partOf'] = part_of(presenter) if presenter&.member_of_collection_ids.present?
        hash['homepage'] = homepage(presenter)
        # TODO: MAY BE A TEMPORARY IMPLEMENTATION UNTIL #behavior IS SET UP
        hash['behavior'] = ['paged'] if presenter.human_readable_type == 'Book'
        hash['behavior'] = ['individuals'] if presenter.human_readable_type == 'Compound Object'
        hash = send("sanitize_v#{@version}", hash: hash, presenter: presenter)
        send("sorted_canvases_v#{@version}", hash: hash, sort_field: IiifPrint.config.sort_iiif_manifest_canvases_by)
      end

      ##
      # @return [Array<Hash>] the "homepage" property for the manifest.json
      def homepage(presenter)
        [{
          id: presenter.work_url,
          label: {
            none: presenter.title
          },
          type: 'Text',
          format: 'text/html'
        }]
      end

      # TODO: MAY BE A TEMPORARY IMPLEMENTATION UNTIL #is_part_of IS SET UP
      ##
      # @return [Arrary<Hash>] the "partOf" property for the manifest.json of all Collections the work is apart of
      def part_of(presenter)
        presenter.member_of_collection_ids.map do |id|
          {
            id: presenter.collection_url(id),
            type: "Collection"
          }
        end
      end

      ##
      # @return [Array<Hash>] the hardcoded "provider" property for the manifest.json
      def provider
        [{
          id: "https://www.lib.utk.edu/about/",
          type: "Agent",
          label: {
            en: ["University of Tennessee, Knoxville. Libraries"]
          },
          homepage: [
            { id: "https://www.lib.utk.edu/",
              type: "Text",
              label: {
                en: ["University of Tennessee Libraries Homepage"]
              },
              format: "text/html" }
          ],
          logo: [
            {
              id: "https://utkdigitalinitiatives.github.io/iiif-level-0/ut_libraries_centered/full/full/0/default.jpg",
              type: "Image",
              format: "image/jpeg",
              width: 200,
              height: 200
            }
          ]
        }]
      end

      ##
      # @return [Hash<Array>] the Hash to be used by "label" to change `&amp;`	to `&`
      # @see #loof
      def sanitize_value(text)
        return loof(text) unless text.is_a?(Hash)
        text[text.keys.first] = text.values.flatten.map { |value| loof(value) }
        text
      end

      ##
      # @return [String] the String that gets unescaped since Loofah is too aggressive for example
      #   it changes to `&` to `&amp;` which will be displayed in the Universal Viewer and manifest
      # @see #sanitize_value
      def loof(text)
        CGI.unescapeHTML(Loofah.fragment(text.to_s).scrub!(:prune).to_s)
      end
  end
end

Hyrax::ManifestBuilderService.prepend(Hyrax::ManifestBuilderServiceDecorator)
# Hyrax::ManifestBuilderService.singleton_class.prepend(Hyrax::ManifestBuilderServiceDecorator::ClassMethods)
