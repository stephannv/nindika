# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::ItemDataAdapter, type: :lib do
  describe "#item_type" do
    context "when dlcType is nil" do
      it "returns ItemTypes::GAME" do
        adapted_data = described_class.adapt({ "dlcType" => nil })

        expect(adapted_data[:item_type]).to eq ItemTypes::GAME
      end
    end

    context "when dlcType is Individual" do
      it "returns ItemTypes::DLC" do
        adapted_data = described_class.adapt({ "dlcType" => "Individual" })

        expect(adapted_data[:item_type]).to eq ItemTypes::DLC
      end
    end

    context "when dlcType is Bundle" do
      it "returns ItemTypes::DLC_BUNDLE" do
        adapted_data = described_class.adapt({ "dlcType" => "Bundle" })

        expect(adapted_data[:item_type]).to eq ItemTypes::DLC_BUNDLE
      end
    end

    context "when dlcType is ROM Bundle" do
      it "returns ItemTypes::GAME_BUNDLE" do
        adapted_data = described_class.adapt({ "dlcType" => "ROM Bundle" })

        expect(adapted_data[:item_type]).to eq ItemTypes::GAME_BUNDLE
      end
    end

    context "when dlcType is unknown" do
      it "raises error" do
        expect do
          described_class.adapt({ "dlcType" => "new type" })
        end.to raise_error("NOT MAPPED ITEM TYPE: new type")
      end
    end
  end

  describe "#title" do
    context "when title is present" do
      it "returns title without ® ™ symbols" do
        adapted_data = described_class.adapt({ "title" => "My Game®™" })

        expect(adapted_data[:title]).to eq "My Game"
      end
    end

    context "when title isn`t present" do
      it "returns nil" do
        adapted_data = described_class.adapt({ "title" => nil })

        expect(adapted_data[:title]).to be_nil
      end
    end
  end

  describe "#description" do
    it "returns description content" do
      adapted_data = described_class.adapt({ "description" => "Some description here" })

      expect(adapted_data[:description]).to eq "Some description here"
    end
  end

  describe "#release_date" do
    it "returns 31/12/2049 as placeholder date" do
      adapted_data = described_class.adapt({})

      expect(adapted_data[:release_date]).to eq Date.parse("31/12/2049")
    end
  end

  describe "#release_date_display" do
    it "returns TBD as placeholder date" do
      adapted_data = described_class.adapt({})

      expect(adapted_data[:release_date_display]).to eq "TBD"
    end
  end

  describe "#website_url" do
    it "adds nintendo domain as prefix to url and transform pt-br to pt-BR" do
      adapted_data = described_class.adapt({ "url" => "/pt-br/some-url-here" })

      expect(adapted_data[:website_url]).to eq "https://www.nintendo.com/pt-BR/some-url-here"
    end
  end

  describe "#banner_url" do
    it "adds nintendo assets domain as prefix to url" do
      prefix = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_720/v1"
      adapted_data = described_class.adapt({ "productImage" => "some-img-url" })

      expect(adapted_data[:banner_url]).to eq "#{prefix}/some-img-url"
    end
  end

  describe "#external_id" do
    it "returns objectID" do
      adapted_data = described_class.adapt({ "objectID" => "some id here" })

      expect(adapted_data[:external_id]).to eq "some id here"
    end
  end

  describe "#nsuid" do
    it "returns nsuid" do
      adapted_data = described_class.adapt({ "nsuid" => "some nsuid here" })

      expect(adapted_data[:nsuid]).to eq "some nsuid here"
    end
  end

  describe "#genres" do
    it "returns genres" do
      genres = ["Role-Playing", "Action", "First Person"]
      adapted_data = described_class.adapt({ "genres" => genres })

      expect(adapted_data[:genres]).to eq genres
    end
  end

  describe "#developer" do
    it "returns softwareDeveloper" do
      adapted_data = described_class.adapt({ "softwareDeveloper" => "some developer" })

      expect(adapted_data[:developer]).to eq "some developer"
    end
  end

  describe "#publisher" do
    it "returns softwarePublisher" do
      adapted_data = described_class.adapt({ "softwarePublisher" => "some publisher" })

      expect(adapted_data[:publisher]).to eq "some publisher"
    end
  end

  describe "#franchises" do
    let(:data) { { "franchises" => [Faker::Lorem.word] } }

    it "returns franchises" do
      franchises = ["Super Frog", "Cute Cat"]
      adapted_data = described_class.adapt({ "franchises" => franchises })

      expect(adapted_data[:franchises]).to eq franchises
    end
  end

  describe "#with_demo" do
    context "when demo_nsuid is present" do
      it "returns true" do
        adapted_data = described_class.adapt({ "demoNsuid" => "some nsuid" })

        expect(adapted_data[:with_demo]).to be true
      end
    end

    context "when demo_nsuid is blank" do
      it "returns false" do
        adapted_data = described_class.adapt({ "demoNsuid" => nil })

        expect(adapted_data[:with_demo]).to be false
      end
    end
  end

  describe "#num_of_players" do
    it "returns playerCount" do
      adapted_data = described_class.adapt({ "playerCount" => "85 players" })

      expect(adapted_data[:num_of_players]).to eq "85 players"
    end
  end
end
