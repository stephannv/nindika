# frozen_string_literal: true

class Navigation::PaginationComponent < ViewComponent::Base
  def initialize(pagy:)
    @pagy = pagy
  end

  private

  attr_reader :pagy
end
