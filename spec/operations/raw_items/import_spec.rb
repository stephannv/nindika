# frozen_string_literal: true

require "rails_helper"

RSpec.describe RawItems::Import, type: :action do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "Play actors" do
    subject { described_class.play_actors.map(&:values).flatten }

    it { is_expected.to contain_exactly(RawItems::FetchAll, RawItems::Create, RawItems::Process) }
  end
end
