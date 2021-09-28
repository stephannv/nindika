# frozen_string_literal: true

Rails.application.routes.draw do
  mount Nindika::BaseAPI => '/'
end
