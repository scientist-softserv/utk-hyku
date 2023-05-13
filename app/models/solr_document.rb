# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior
  include AllinsonFlex::DynamicSolrDocument

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  attribute :extent, Solr::Array, 'extent_tesim'
  attribute :rendering_ids, Solr::Array, 'hasFormat_ssim'
  attribute :account_cname, Solr::Array, 'account_cname_tesim'

  def date_created_d
    self['date_created_d_tesim']
  end

  def date_issued
    self['date_issued_tesim']
  end

  def date_issued_d
    self['date_issued_d_tesim']
  end

  def extent
    self['extent_tesim']
  end

  def form
    self['form_tesim']
  end

  def publication_place
    self['publication_place_tesim']
  end

  def repository
    self['repository_tesim']
  end

  def resource_link
    self['resource_link_tesim']
  end

  def spatial
    self['spatial_tesim']
  end

  def utk_contributor
    self['utk_contributor_tesim']
  end

  def utk_creator
    self['utk_creator_tesim']
  end

  def utk_publisher
    self['utk_publisher_tesim']
  end

  def intermediate_file?
    self['rdf_type_ssim']
      .map(&:downcase).join.include?(Hyrax::ConditionalDerivativeDecorator::INTERMEDIATE_FILE_TYPE_TEXT)
  end

  field_semantics.merge!(
    contributor: 'contributor_tesim',
    creator: 'creator_tesim',
    date: 'date_created_tesim',
    description: 'description_tesim',
    identifier: 'identifier_tesim',
    language: 'language_tesim',
    publisher: 'publisher_tesim',
    relation: 'nesting_collection__pathnames_ssim',
    rights: 'rights_statement_tesim',
    subject: 'subject_tesim',
    title: 'title_tesim',
    type: 'human_readable_type_tesim'
  )
end
