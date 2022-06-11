# frozen_string_literal: true

class App::Navbar::GameMenuComponent < ViewComponent::Base
  def active_class_for_parent_link
    request.path.include?(games_path) ? "uk-active" : nil
  end

  def active_class_for_link(path)
    current_page?(path) ? "uk-active" : nil
  end
end
