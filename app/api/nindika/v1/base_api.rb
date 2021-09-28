# frozen_string_literal: true

module Nindika
  module V1
    class BaseAPI < Grape::API
      format :json
      version :v1, using: :path

      mount Nindika::V1::GamesAPI
    end
  end
end
