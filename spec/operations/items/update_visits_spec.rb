# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::UpdateVisits, type: :operations do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { expect(inputs).to be_empty }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    let!(:zelda) { create(:item, title: "zelda") }
    let!(:mega_man) { create(:item, title: "megaman") }
    let!(:metroid) { create(:item, title: "metroid") }

    let(:all_time_stats) do
      [
        { "slug" => "zelda", "visitors" => 200 },
        { "slug" => "megaman", "visitors" => 100 },
        { "slug" => "mega-man", "visitors" => 50 },
        { "slug" => "not-found", "visitors" => 50 }
      ]
    end

    let(:last_week_stats) do
      [
        { "slug" => "zelda", "visitors" => 20 },
        { "slug" => "megaman", "visitors" => 5 },
        { "slug" => "mega-man", "visitors" => 5 },
        { "slug" => "not-found", "visitors" => 5 }
      ]
    end

    before do
      mega_man.update(title: "mega man")
      allow(VisitsCollector).to receive(:all_time_game_pages_stats).and_return(all_time_stats)
      allow(VisitsCollector).to receive(:last_week_game_pages_stats).and_return(last_week_stats)
    end

    context "when game doesn`t have stats" do
      it "updates all visit counters to zero" do
        described_class.call

        expect(metroid.reload.attributes).to include("all_time_visits" => 0, "last_week_visits" => 0)
      end
    end

    context "when game has multiple slugs with stats" do
      it "updates all visit counters with stats sum" do
        described_class.call

        expect(mega_man.reload.attributes).to include("all_time_visits" => 150, "last_week_visits" => 10)
      end
    end

    context "when game has only one slug with stats" do
      it "updates all visit counters with stats values" do
        described_class.call

        expect(zelda.reload.attributes).to include("all_time_visits" => 200, "last_week_visits" => 20)
      end
    end

    context "when stats has slug from a not existing game" do
      it "doesn`t raise error" do
        expect { described_class.call }.not_to raise_error
      end
    end
  end
end
