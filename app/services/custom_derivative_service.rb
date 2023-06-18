# frozen_string_literal: true

# @api public
module CustomDerivativeService
  def valid?
    Hyrax::ConditionalDerivativeDecorator.generate_derivatives_for?(file_set: file_set)
  end
end

Hyrax::DerivativeService.services.each { |service| service.prepend(CustomDerivativeService) }
