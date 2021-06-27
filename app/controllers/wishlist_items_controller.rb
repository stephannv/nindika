# frozen_string_literal: true

class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    result = WishlistItems::Create.result(user: current_user, item_id: params[:item_id])

    if result.success?
      head :created
    else
      render json: { message: t('.error') }, status: :unprocessable_entity
    end
  end

  def destroy
    result = WishlistItems::Destroy.result(user: current_user, item_id: params[:item_id])

    if result.success?
      head :no_content
    else
      render json: { message: t('.error') }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    head :unauthorized if current_user.blank?
  end
end
