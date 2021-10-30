# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nindika::V1::BaseAPI, type: :api do
  describe 'Configurations' do
    it 'has json format' do
      expect(described_class.format).to eq :json
    end

    it 'has v1 version' do
      expect(described_class.version).to eq :v1
    end
  end
end
