# frozen_string_literal: true

# @api public
module CustomDerivativeService
    def valid?
        false if file_set.rdf_type&.join&.downcase&.include?("intermediate_file")
    end
end

Hyrax::DerivativeService.services.each { |service| service.prepend(CustomDerivativeService) }