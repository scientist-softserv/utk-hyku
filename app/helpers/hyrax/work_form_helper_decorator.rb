# frozen_string_literal: true

# OVERRIDE HYRAX 3.4.0 bug fix for select_options undefined for an array error
# due to allinson flex 1.0 #admin_set_options override

module Hyrax
  module WorkFormHelperDecorator
    ##
    # @todo this implementation hits database backends (solr) and is invoked
    #   from views. refactor to avoid
    # @return  [Array<Array<String, String, Hash>] options for the admin set drop down.
    def admin_set_options
      service = Hyrax::AdminSetService.new(controller)
      Hyrax::AdminSetOptionsPresenter.new(service).select_options
    end
  end
end

# included directly in hyrax_helper.rb to overcome load order problem
