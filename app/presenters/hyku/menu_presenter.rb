module Hyku
  # view-model for the admin menu
  class MenuPresenter
    def initialize(view_context)
      @view_context = view_context
    end

    attr_reader :view_context

    delegate :controller_name, :content_tag, :current_page?, :link_to,
             to: :view_context

    # Returns true if the current controller happens to be one of the controllers that deals
    # with settings.  This is used to keep the parent section on the sidebar open.
    def settings_section?
      %w(appearances content_blocks labels features).include?(controller_name)
    end

    def nav_link(href)
      content_tag(:li, class: ('active' if current_page?(href))) do
        link_to(href) do
          yield
        end
      end
    end
  end
end
