# frozen_string_literal: true

# @api public
module CustomDerivativeService
  def valid?
    file_set.rdf_type&.join&.downcase&.include?(Hyrax::ConditionalDerivativeDecorator::INTERMEDIATE_FILE_TYPE_TEXT)
  end
end

Hyrax::DerivativeService.services.each { |service| service.prepend(CustomDerivativeService) }
