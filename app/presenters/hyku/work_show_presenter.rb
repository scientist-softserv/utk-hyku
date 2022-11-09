# frozen_string_literal: true

# OVERRIDE here to add featured collection methods and to delegate collection presenters to the member presenter factory

module Hyku
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    # Adds behaviors for hyrax-iiif_av plugin.
    include Hyrax::IiifAv::DisplaysIiifAv
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::IiifAv::IiifFileSetPresenter

    delegate :title_or_label, :extent, to: :solr_document

    # OVERRIDE Hyrax v2.9.0 here to make featured collections work
    delegate :collection_presenters, to: :member_presenter_factory

    # assumes there can only be one doi
    def doi
      doi_regex = %r{10\.\d{4,9}\/[-._;()\/:A-Z0-9]+}i
      doi = extract_from_identifier(doi_regex)
      doi&.join
    end

    # unlike doi, there can be multiple isbns
    def isbns
      isbn_regex = /((?:ISBN[- ]*13|ISBN[- ]*10|)\s*97[89][ -]*\d{1,5}[ -]*\d{1,7}[ -]*\d{1,6}[ -]*\d)|
                    ((?:[0-9][-]*){9}[ -]*[xX])|(^(?:[0-9][-]*){10}$)/x
      isbns = extract_from_identifier(isbn_regex)
      isbns&.flatten&.compact
    end

    # OVERRIDE here for featured collection methods
    # Begin Featured Collections Methods
    def collection_featurable?
      user_can_feature_collection? && solr_document.public?
    end

    def display_feature_collection_link?
      collection_featurable? && FeaturedCollection.can_create_another? && !collection_featured?
    end

    def display_unfeature_collection_link?
      collection_featurable? && collection_featured?
    end

    def collection_featured?
      # only look this up if it's not boolean; ||= won't work here
      if @collection_featured.nil?
        @collection_featured = FeaturedCollection.where(collection_id: solr_document.id).exists?
      end
      @collection_featured
    end

    def user_can_feature_collection?
      current_ability.can?(:create, FeaturedCollection)
    end
    # End Featured Collections Methods

    # @return [Boolean] render a IIIF viewer
    def iiif_viewer?
      representative_id.present? &&
        representative_presenter.present? &&
        iiif_media? &&
        Hyrax.config.iiif_image_server? &&
        members_include_viewable?
    end

    def iiif_media?
      representative_presenter.image? ||
        representative_presenter.video? ||
        representative_presenter.audio?
    end

    def members_include_viewable?
      file_set_presenters.any? { |presenter| (presenter.image? || presenter.video? || presenter.audio?) && current_ability.can?(:read, presenter.id) }
    end

    private

      def extract_from_identifier(rgx)
        if solr_document['identifier_tesim'].present?
          ref = solr_document['identifier_tesim'].map do |str|
            str.scan(rgx)
          end
        end
        ref
      end
  end
end
