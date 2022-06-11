# frozen_string_literal: true

require "rails_helper"

RSpec.describe PriceStates, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include "pre_order" }
  it { is_expected.to include "on_sale" }
  it { is_expected.to include "unavailable" }
  it { is_expected.to include "unreleased" }
end
