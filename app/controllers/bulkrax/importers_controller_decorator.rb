# frozen_string_literal: true

# OVERRIDE class from Bulkrax v4.2.1

module Bulkrax
  module ImportersControllerDecorator
    # OVERRIDE: Bulkrax importer without Allinson flex schema redirects to metadata profile page.
    def new
      if AllinsonFlex::Profile.none?
        redirect_to '/profiles', alert: 'Import metadata profile to enable Bulkrax importer.'
      else
        @importer = Bulkrax::Importer.new
      end
      if api_request?
        json_response('new')
      else
        add_importer_breadcrumbs
        add_breadcrumb 'New'
      end
    end
  end
end

Bulkrax::ImportersController.prepend(Bulkrax::ImportersControllerDecorator)
