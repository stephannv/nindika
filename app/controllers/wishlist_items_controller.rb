# frozen_string_literal: true

class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    result = WishlistItems::Create.result(user: current_user, item_id: params[:item_id])

    return if result.failure?

    button = button_template(item_id: params[:item_id], wishlisted: true, style: params[:style])
    render turbo_stream: turbo_stream.replace("wishlist_item_#{params[:item_id]}", button)
  end

  def destroy
    result = WishlistItems::Destroy.result(user: current_user, item_id: params[:item_id])

    return if result.failure?

    button = button_template(item_id: params[:item_id], wishlisted: false, style: params[:style])
    render turbo_stream: turbo_stream.replace("wishlist_item_#{params[:item_id]}", button)
  end

  private

  def button_template(item_id:, wishlisted:, style:)
    WishlistItems::ButtonComponent.new(item_id: params[:item_id], wishlisted: true, style: params[:style])
      .render_in(view_context)
  end
end
