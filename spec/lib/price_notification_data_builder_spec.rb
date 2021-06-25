# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceNotificationDataBuilder, type: :lib do
  describe '#build' do
    subject(:data) { described_class.build(price: price) }

    context 'when price is a newly created record without discount' do
      let(:price) { create(:price) }
      let(:item) { price.item }

      it 'builds price_uncovered notification data' do
        expect(data).to eq(
          notification_type: NotificationTypes::PRICE_UNCOVERED,
          title: item.title,
          body: NotificationTypes.t(NotificationTypes::PRICE_UNCOVERED),
          url: Rails.application.routes.url_helpers.game_url(item.slug),
          image_url: item.boxart_url,
          fields: [
            { name: :current_price, value: price.current_amount.format },
            { name: :website_url, value: item.website_url }
          ]
        )
      end
    end

    context 'when price is persisted record and received discount' do
      let(:price) { create(:price) }
      let(:item) { price.item }

      before do
        price.reload
        discount_attributes = attributes_for(:price, :with_discount)
          .slice(:discount_amount, :discount_started_at, :discount_ends_at, :discount_percentage)
        price.update!(discount_attributes)
      end

      it 'builds discounted_price notification data' do
        expect(data).to eq(
          notification_type: NotificationTypes::DISCOUNTED_PRICE,
          title: item.title,
          body: NotificationTypes.t(NotificationTypes::DISCOUNTED_PRICE),
          url: Rails.application.routes.url_helpers.game_url(item.slug),
          image_url: item.boxart_url,
          fields: [
            { name: :current_price, value: price.current_amount.format },
            { name: :website_url, value: item.website_url },
            { name: :original_price, value: price.regular_amount.format },
            { name: :discount_percentage, value: "#{price.discount_percentage}%" },
            { name: :started_at, value: price.discount_started_at },
            { name: :ends_at, value: price.discount_ends_at }
          ]
        )
      end
    end

    context 'when price is persisted record and regular amount was updated' do
      let(:price) { create(:price) }
      let(:item) { price.item }
      let!(:old_amount) { price.regular_amount }

      before do
        price.update(regular_amount: price.regular_amount + Money.new(1000))
      end

      it 'builds price_readjustment notification data' do
        expect(data).to eq(
          notification_type: NotificationTypes::PRICE_READJUSTMENT,
          title: item.title,
          body: NotificationTypes.t(NotificationTypes::PRICE_READJUSTMENT),
          url: Rails.application.routes.url_helpers.game_url(item.slug),
          image_url: item.boxart_url,
          fields: [
            { name: :current_price, value: price.current_amount.format },
            { name: :website_url, value: item.website_url },
            { name: :old_price, value: old_amount.format }
          ]
        )
      end
    end

    context 'when price is a newly created record with discount' do
      let(:price) { create(:price, :with_discount) }
      let(:item) { price.item }

      it 'builds pre_order_discount notification data' do
        expect(data).to eq(
          notification_type: NotificationTypes::PRE_ORDER_DISCOUNT,
          title: item.title,
          body: NotificationTypes.t(NotificationTypes::PRE_ORDER_DISCOUNT),
          url: Rails.application.routes.url_helpers.game_url(item.slug),
          image_url: item.boxart_url,
          fields: [
            { name: :current_price, value: price.current_amount.format },
            { name: :website_url, value: item.website_url },
            { name: :original_price, value: price.regular_amount.format },
            { name: :discount_percentage, value: "#{price.discount_percentage}%" },
            { name: :started_at, value: price.discount_started_at },
            { name: :ends_at, value: price.discount_ends_at }
          ]
        )
      end
    end

    context 'when price is a persisted record without modifications' do
      let(:price) { create(:price) }

      before { price.reload }

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end
end
