# frozen_string_literal: true

module Hyrax
  module ConditionalDerivativeDecorator
    INTERMEDIATE_FILE_TYPE_TEXT = "intermediatefile"
    WORKS_WITH_PDF_FILE_SETS = [Pdf, GenericWork].freeze

    ##
    # @api public
    #
    # @param file_set [FileSet]
    #
    # @return [TrueClass] when we should generate derivatives for the given :file_set
    # @return [FalseClass] when we should **not** generate derivatives for the given :file_set
    def self.generate_derivatives_for?(file_set:)
      intermediate_file?(object: file_set) || WORKS_WITH_PDF_FILE_SETS.include?(file_set.try(:parent).class)
    end

    ##
    # @api public
    #
    # @note The :object parameter can be an instance of any class that inherits from ActiveFedora::Base
    #   (which includes all Hyrax curation concern objects), FileSet, or SolrDocument.
    #
    # @param object [ActiveFedora::Base, FileSet, SolrDocument]
    # @param intermediate_file_type_text [String]
    #
    # @return [TrueClass] when the given :object is an intermediate file
    # @return [FalseClass] when the given :object is **not** an intermediate file
    def self.intermediate_file?(object:, intermediate_file_type_text: INTERMEDIATE_FILE_TYPE_TEXT)
      rdf_type = if object.is_a?(::SolrDocument)
                   object['rdf_type_ssim']
                 else
                   object.try(:rdf_type).presence
                 end

      return false unless rdf_type

      rdf_type.join.downcase.include?(intermediate_file_type_text)
    end

    ##
    # @return [TrueClass] when the associated file_set should use the associated derivative
    # @return [FalseClass] when the associated file_set should **not** use the associated derivative
    #         service
    def valid?
      # Yes, I'm calling the module method :generate_derivatives_for? because that is logic likely
      # to repeat elsewhere.
      return false unless ConditionalDerivativeDecorator.generate_derivatives_for?(file_set: file_set)
      super
    end
  end
end

# NOTE: Until we add the IIIF Print gem, this is adequate for short-circuiting running derivatives.
Hyrax::FileSetDerivativesService.prepend(Hyrax::ConditionalDerivativeDecorator)
