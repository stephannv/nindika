# frozen_string_literal: true

module Nindika
  class BaseAPI < Grape::API
    cascade false

    mount Nindika::V1::BaseAPI
  end
end
