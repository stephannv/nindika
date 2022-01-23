# frozen_string_literal: true

class FeaturedGamesController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! to: :create?, with: FeaturedGamePolicy

    result = Items::Update.result(id: params[:id], attributes: { featured: true })

    if result.success?
      head :created
    else
      render json: { message: t('.error') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! to: :destroy?, with: FeaturedGamePolicy

    result = Items::Update.result(id: params[:id], attributes: { featured: false })

    if result.success?
      head :no_content
    else
      render json: { message: t('.error') }, status: :unprocessable_entity
    end
  end

  def implicit_authorization_target
    Item
  end
end
