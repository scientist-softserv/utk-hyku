# frozen_string_literal: true

module Hyrax
  module ConditionalDerivativeDecorator
    INTERMEDIATE_FILE_TYPE_TEXT = "intermediatefile"

    ##
    # @api public
    #
    # @param file_set [FileSet]
    # @param intermediate_file_type_text [String]
    #
    # @return [TrueClass] when we should generate derivatives for the given :file_set
    # @return [FalseClass] when we should **not** generate derivatives for the given :file_set
    def self.generate_derivatives_for?(file_set:, intermediate_file_type_text: INTERMEDIATE_FILE_TYPE_TEXT)
      return true unless file_set.respond_to?(:rdf_type)
      return false if file_set.rdf_type&.join&.downcase&.include?(intermediate_file_type_text)

      true
    end

    ##
    # @return [TrueClass] when the associated file_set should use the associated derivative
    # @return [FalseClass] when the associated file_set should **not** use the associated derivative
    #         service
    def valid?
      # Yes, I'm calling the module method :generate_derivatives_for? because that is logic likely
      # to repeat elsewhere.
      return false unless self.class.generate_derivatives_for?(file_set: file_set)
      super
    end
  end
end
