# frozen_string_literal: true

class FeaturedGamePolicy < ApplicationPolicy
  def create?
    user.try(:admin?)
  end

  def destroy?
    user.try(:admin?)
  end
end
