module ApplicationHelper
  include ::HyraxHelper
  include ContentBlockHelper

  def nav_link(href)
    content_tag(:li, class: ('active' if current_page?(href))) do
      link_to(href) do
        yield
      end
    end
  end
end
