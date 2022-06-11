# frozen_string_literal: true

class Items::Details::HeaderComponent < ViewComponent::Base
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def center_images_class
    # Headers images should be centered on larger screens when there are less than 3 images (cover + 2 screenshots)
    item.screenshot_urls.size <= 1 ? "uk-flex-center@m" : ""
  end
end
