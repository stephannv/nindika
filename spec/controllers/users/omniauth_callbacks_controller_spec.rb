# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  %i[developer].each do |provider|
    describe "POST /users/auth/#{provider}/callback" do
      let(:auth) { OmniAuth::AuthHash.new(Faker::Omniauth.twitter) }

      before do
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = auth
      end

      context "when omniauth sign in is succesful" do
        let(:message) { I18n.t("users.omniauth_callbacks.#{provider}.success", user: user.name) }
        let(:user) { create(:user) }

        before do
          allow(Users::GetFromOmniauth).to receive(:result)
            .with(auth: auth)
            .and_return(ServiceActor::Result.new(user: user, failure?: false))

          post provider
        end

        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:success].to(message) }
      end

      context "when omniauth sign in is a failure" do
        let(:message) { I18n.t("users.omniauth_callbacks.#{provider}.error") }

        before do
          allow(Users::GetFromOmniauth).to receive(:result)
            .with(auth: auth)
            .and_return(ServiceActor::Result.new(user: nil, failure?: true))

          post provider
        end

        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:danger].to(message) }
      end
    end
  end
end
