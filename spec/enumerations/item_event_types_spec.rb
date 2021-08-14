# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemEventTypes, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include 'game_added' }
  it { is_expected.to include 'price_added' }
  it { is_expected.to include 'discount' }
  it { is_expected.to include 'permanent_price_change' }
  it { is_expected.to include 'price_state_change' }
end
