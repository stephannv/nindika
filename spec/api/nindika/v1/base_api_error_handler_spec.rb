# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nindika::V1::BaseAPI, type: :api do
  subject(:api) { Class.new(described_class) }

  def app
    api
  end

  describe 'Rescuing Grape::Exceptions::ValidationErrors' do
    before do
      api.params do
        requires :some_param, type: String
      end

      api.get '/example' do
        'something'
      end
    end

    it 'return errors as json' do
      get '/v1/example'

      expect(response.body).to eq({ errors: ['some_param is missing'] }.to_json)
    end

    it 'return status 400 - bad request' do
      get '/v1/example'

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Rescuing ActiveRecord::RecordNotFound' do
    before do
      api.get '/example' do
        raise ActiveRecord::RecordNotFound, 'not found'
      end
    end

    it 'return object errors as json' do
      get '/v1/example'

      expect(response.body).to eq({ error: 'not found' }.to_json)
    end

    it 'returns status 404 - not found' do
      get '/v1/example'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'Rescuing unexpected error' do
    before do
      api.get '/example' do
        raise 'some error'
      end
    end

    context 'when environment is production' do
      before { allow(Rails.env).to receive(:production?).and_return(true) }

      it 'returns errors as json' do
        get '/v1/example'

        expect(response.body).to eq({ error: 'Internal server error' }.to_json)
      end

      it 'returns status 500 - server error' do
        get '/v1/example'

        expect(response).to have_http_status(:server_error)
      end
    end

    context 'when environment isn`t production' do
      before { allow(Rails.env).to receive(:production?).and_return(false) }

      it 'raises error' do
        expect { get '/v1/example' }.to raise_error(StandardError)
      end
    end
  end
end
