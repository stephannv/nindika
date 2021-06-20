# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationTypes, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include 'price_uncovered' }
  it { is_expected.to include 'discounted_price' }
  it { is_expected.to include 'price_readjustment' }
  it { is_expected.to include 'pre_order_discount' }
end
