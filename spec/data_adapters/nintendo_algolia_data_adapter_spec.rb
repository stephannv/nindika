# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NintendoAlgoliaDataAdapter, type: :data_adapters do
  subject(:adapted_data) { described_class.adapt(data) }

  let(:data) { {} }

  describe '#title' do
    context 'when title is present' do
      let(:title) { Faker::Lorem.word }
      let(:data) { { 'title' => "#{title}®™" } }

      it 'returns title without ® ™ symbols' do
        expect(adapted_data[:title]).to eq title
      end
    end

    context 'when title isn`t present' do
      let(:data) { { 'title' => nil } }

      it 'returns nil' do
        expect(adapted_data[:title]).to be_nil
      end
    end
  end

  describe '#description' do
    let(:data) { { 'description' => Faker::Lorem.word } }

    it 'returns description content' do
      expect(adapted_data[:description]).to eq data['description']
    end
  end

  describe '#release_date' do
    context 'when releaseDateDisplay is a valid date' do
      let(:data) { { 'releaseDateDisplay' => Time.zone.yesterday.to_s } }

      it 'returns releaseDateDisplay converted to date' do
        expect(adapted_data[:release_date]).to eq Time.zone.yesterday
      end
    end

    context 'when releaseDateDisplay isn`t valid' do
      let(:data) { { 'releaseDateDisplay' => Faker::Lorem.word } }

      it 'returns 2049-12-31' do
        expect(adapted_data[:release_date]).to eq Date.parse('31/12/2049')
      end
    end
  end

  describe '#release_date_display' do
    context 'when releaseDateDisplay is a valid date' do
      let(:data) { { 'releaseDateDisplay' => (Time.zone.today - 1).to_s } }

      it 'returns releaseDateDisplay converted to date' do
        expect(adapted_data[:release_date_display]).to eq (Time.zone.today - 1).to_s
      end
    end

    context 'when releaseDateDisplay isn`t valid' do
      let(:data) { { 'releaseDateDisplay' => Faker::Lorem.word } }

      it 'returns releaseDateDisplay' do
        expect(adapted_data[:release_date_display]).to eq data['releaseDateDisplay']
      end
    end
  end

  describe '#website_url' do
    let(:data) { { 'url' => Faker::Lorem.word } }

    it 'adds nintendo america domain as prefix to url' do
      expect(adapted_data[:website_url]).to eq "https://www.nintendo.com#{data['url']}"
    end
  end

  describe '#boxart_url' do
    let(:data) { { 'boxart' => Faker::Lorem.word } }

    it 'adds nintendo domain as prefix to boxart' do
      expect(adapted_data[:boxart_url]).to eq "https://www.nintendo.com#{data['boxart']}"
    end
  end

  describe '#banner_url' do
    context 'when horizontalHeaderImage is present' do
      let(:data) { { 'horizontalHeaderImage' => Faker::Lorem.word } }

      it 'adds nintendo domain as prefix to horizontalHeaderImage' do
        expect(adapted_data[:banner_url]).to eq "https://www.nintendo.com#{data['horizontalHeaderImage']}"
      end
    end

    context 'when horizontalHeaderImage is blank' do
      let(:data) { { 'horizontalHeaderImage' => '' } }

      it 'returns nil' do
        expect(adapted_data[:banner_url]).to be_nil
      end
    end
  end

  describe '#external_id' do
    let(:data) { { 'objectID' => Faker::Lorem.word } }

    it 'returns objectID' do
      expect(adapted_data[:external_id]).to eq data['objectID']
    end
  end

  describe '#nsuid' do
    let(:data) { { 'nsuid' => Faker::Lorem.word } }

    it 'returns nsuid' do
      expect(adapted_data[:nsuid]).to eq data['nsuid']
    end
  end

  describe '#genres' do
    let(:data) { { 'genres' => [Faker::Lorem.word] } }

    it 'returns genres' do
      expect(adapted_data[:genres]).to eq data['genres']
    end
  end

  describe '#developers' do
    let(:data) { { 'developers' => [Faker::Lorem.word] } }

    it 'returns developers' do
      expect(adapted_data[:developers]).to eq data['developers']
    end
  end

  describe '#publishers' do
    let(:data) { { 'publishers' => [Faker::Lorem.word] } }

    it 'returns publishers' do
      expect(adapted_data[:publishers]).to eq data['publishers']
    end
  end

  describe '#franchises' do
    let(:data) { { 'franchises' => [Faker::Lorem.word] } }

    it 'returns franchises' do
      expect(adapted_data[:franchises]).to eq data['franchises']
    end
  end

  describe '#extra' do
    let(:data) do
      {
        'freeToStart' => true,
        'generalFilters' => [
          'Demo available', 'DLC available', 'Online Play via Nintendo Switch Online', 'Nintendo Switch Game Voucher'
        ],
        'numOfPlayers' => Faker::Lorem.word,
        'filterShops' => ['At retail']
      }
    end

    it 'adds free_to_start to hash' do
      expect(adapted_data.dig(:extra, :free_to_start)).to be true
    end

    it 'adds demo_available trait to hash' do
      expect(adapted_data.dig(:extra, :demo_available)).to be true
    end

    it 'adds has_addon_content trait to hash' do
      expect(adapted_data.dig(:extra, :has_addon_content)).to be true
    end

    it 'adds num_of_players trait to hash' do
      expect(adapted_data.dig(:extra, :num_of_players)).to eq data['numOfPlayers']
    end

    it 'adds paid_subscription_required trait to hash' do
      expect(adapted_data.dig(:extra, :paid_subscription_required)).to be true
    end

    it 'adds physical_version trait to hash' do
      expect(adapted_data.dig(:extra, :physical_version)).to be true
    end

    it 'adds voucher_redeemable trait to hash' do
      expect(adapted_data.dig(:extra, :voucher_redeemable)).to be true
    end
  end
end
