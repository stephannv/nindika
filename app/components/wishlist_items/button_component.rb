# frozen_string_literal: true

module WishlistItems
  class ButtonComponent < ViewComponent::Base
    include Turbo::FramesHelper

    ACTIVE_CLASSES = {
      square: "btn btn-ghost btn-square btn-sm",
      block: "btn btn-block btn-primary gap-2"
    }.freeze

    NOT_ACTIVE_CLASSES = {
      square: "btn btn-ghost btn-square btn-sm",
      block: "btn btn-block btn-outline btn-outline gap-2"
    }.freeze

    def initialize(item_id:, wishlisted:, style: :square)
      @item_id = item_id
      @wishlisted = wishlisted
      @style = (style || :square).to_sym
    end

    private

    attr_reader :item_id, :wishlisted, :style

    def turbo_frame_id
      "wishlist_item_#{item_id}"
    end

    def button
      button_to wishlist_item_path(item_id), method: request_method, class: button_classes, params: form_params do
        button_content
      end
    end

    def not_signed_in_button
      link_to new_user_session_path, class: button_classes do
        button_content
      end
    end

    def button_classes
      wishlisted ? ACTIVE_CLASSES[style] : NOT_ACTIVE_CLASSES[style]
    end

    def request_method
      wishlisted ? :delete : :post
    end

    def form_params
      { style: style }
    end

    def button_content
      style == :square ? square_button_content : block_button_content
    end

    def square_button_content
      wishlisted ? checked_bookmark_icon : unchecked_bookmark_icon
    end

    def block_button_content
      button_text = wishlisted ? t(".remove") : t(".add")

      tag.span(button_text) + unchecked_bookmark_icon
    end

    def unchecked_bookmark_icon
      bookmark_icon(classes: "fill-transparent stroke-current")
    end

    def checked_bookmark_icon
      bookmark_icon(classes: "fill-primary stroke-primary")
    end

    def bookmark_icon(classes:)
      tag.svg(class: ["h-6 w-6 stroke-2", classes], xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 24 24") do
        tag.path(
          "stroke-linecap" => "round",
          "stroke-linejoin" => "round",
          "d" => "M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"
        )
      end
    end
  end
end
