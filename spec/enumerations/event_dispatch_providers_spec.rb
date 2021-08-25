# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventDispatchProviders, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include 'telegram' }
end
