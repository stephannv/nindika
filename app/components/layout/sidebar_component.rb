# frozen_string_literal: true

module Layout
  class SidebarComponent < ViewComponent::Base
    private

    def menu_item(url:)
      content_tag :li, class: "font-semibold hover-bordered" do
        link_to url, class: { active: current_page?(url) } do
          yield
        end
      end
    end
  end
end
