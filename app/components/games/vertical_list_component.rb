# frozen_string_literal: true

class Games::VerticalListComponent < ViewComponent::Base
  def initialize(title:, games:, href:)
    @title = title
    @games = games
    @href = href
  end

  private

  attr_accessor :title, :games, :href
end
