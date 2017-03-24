class TransfersController < ApplicationController
  include Hyrax::TransfersControllerBehavior

  # TODO: this should probably happen in hyrax
  layout 'dashboard'
end
