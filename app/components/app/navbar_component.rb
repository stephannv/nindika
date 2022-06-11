# frozen_string_literal: true

class App::NavbarComponent < ViewComponent::Base
  attr_reader :current_user

  def initialize(current_user:)
    @current_user = current_user
  end

  def active_class_for_link(path)
    current_page?(path) ? "uk-active" : nil
  end
end
