# frozen_string_literal: true

class App::SearchFormComponent < ViewComponent::Base
  def initialize(dark: false)
    @dark = dark
  end

  def dark?
    @dark
  end
end
