module Hyku
  module ContentBlockBehavior
    extend ActiveSupport::Concern

    ABOUT = 'about_page'.freeze

    included do
      belongs_to :site
    end

    class_methods do
      def default_scope
        where(site_id: Site.instance.id)
      end

      def about_page
        find_or_create_by(name: ABOUT)
      end

      def about_page=(value)
        about_page.update(value: value)
      end
    end
  end
end
