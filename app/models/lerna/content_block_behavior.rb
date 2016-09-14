module Lerna
  module ContentBlockBehavior
    extend ActiveSupport::Concern

    ABOUT = 'about_page'.freeze

    class_methods do
      def about_page
        find_or_create_by(name: ABOUT)
      end

      def about_page=(value)
        about_page.update(value: value)
      end
    end
  end
end
