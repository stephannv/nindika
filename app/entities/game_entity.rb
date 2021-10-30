# frozen_string_literal: true

class GameEntity < BaseEntity
  expose :id
  expose :title
  expose :slug
  expose :banner_url
  expose :price, using: PriceEntity
end
