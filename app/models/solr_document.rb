# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior
  include AllinsonFlex::DynamicSolrDocument
  include ModsSolrDocument

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
    rdf_type = self['rdf_type_ssim']
    return unless rdf_type

    Hyrax::ConditionalDerivativeDecorator.intermediate_file?(object: self)
  end

  # oai_dc basic terms: [:contributor, :coverage, :creator, :date, :description,
  #                      :format, :identifier, :language, :publisher, :relation,
  #                      :rights, :source, :subject, :title, :type]
  field_semantics.merge!(
    creator: ['creator_tesim', 'architect_tesim', 'artist_tesim',
              'author_tesim', 'composer_tesim', 'illustrator_tesim',
              'interviewee_tesim', 'photographer_tesim', 'utk_artist_tesim',
              'utk_author_tesim', 'utk_creator_tesim', 'utk_interviewee_tesim',
              'utk_photographer_tesim'],
    date: ['date_created_d_tesim', 'date_issued_d_tesim'],
    description: 'abstract_tesim',
    format: ['form_tesim', 'form_local_tesim', 'extent_tesim'],
    identifier: ['identifier_tesim', 'local_identifier_tesim', 'issn_tesim', 'isbn_tesim'],
    language: 'language_tesim',
    publisher: ['provider_tesim', 'intermediate_provider_tesim'],
    rights: ['rights_statement_tesim', 'license_tesim'],
    subject: ['subject_tesim', 'keyword_tesim'],
    title: 'title_tesim',
    type: 'resource_type_tesim'
  )
end
