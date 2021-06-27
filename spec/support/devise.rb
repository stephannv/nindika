# frozen_string_literal: true

require 'devise'

module AuthControllerMacros
  def login_user
    let(:current_user) { FactoryBot.create(:user) }

    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      user = current_user
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend AuthControllerMacros, type: :controller
end
