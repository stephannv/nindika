# frozen_string_literal: true

class App::SidebarComponent < ViewComponent::Base
  def active_class_for_link(path)
    current_page?(path) ? 'uk-active' : nil
  end
end
