# frozen_string_literal: true

# OVERRIDE Hyrax v3.4.1: add collection methods to collection presenter and
#    override to return full banner_file data, rather than only download path to file
# Terms is the list of fields displayed by app/views/collections/_show_descriptions.html.erb
# rubocop:disable Metrics/BlockLength
require_dependency Hyrax::Engine.root.join('app', 'presenters', 'hyrax', 'collection_presenter').to_s

Hyrax::CollectionPresenter.class_eval do
  # OVERRIDE Hyrax - removed size
  delegate :abstract, :collection_link, :date_created_d, :date_issued, :date_issued_d,
           :extent, :form, :publication_place, :repository, :rights_notes, :spatial,
           :utk_contributor, :utk_creator, :utk_publisher, to: :solr_document

  def self.terms
    %i[ total_items
        abstract
        based_near
        collection_link
        creator contributor
        date_created
        date_created_d
        date_issued
        date_issued_d
        extent
        form
        identifier
        keyword
        license
        publication_place
        publisher
        related_url
        repository
        resource_type
        rights_notes
        spatial
        subject language
        utk_contributor
        utk_creator
        utk_publisher ]
  end

  def [](key)
    case key
    when :total_items
      total_items
    else
      solr_document.send key
    end
  end

  # override banner_file in hyrax to include all banner information rather than just relative_path
  def banner_file
    @banner_file ||= begin
      # Find Banner filename
      banner_info = CollectionBrandingInfo.where(collection_id: id, role: "banner")
      filename = File.split(banner_info.first.local_path).last unless banner_info.empty?
      alttext = banner_info.first.alt_text unless banner_info.empty?
      relative_path = "/" + banner_info.first.local_path.split("/")[-4..-1].join("/") unless banner_info.empty?
      { filename: filename, relative_path: relative_path, alt_text: alttext }
    end
  end

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
end
# rubocop:enable Metrics/BlockLength
