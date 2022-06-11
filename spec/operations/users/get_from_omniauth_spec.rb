# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::GetFromOmniauth, type: :operation do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(auth: { type: OmniAuth::AuthHash }) }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to include(user: { type: User }) }
  end

  describe "#call" do
    subject(:result) { described_class.result(auth: auth) }

    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: Faker::Lorem.word,
        uid: Faker::Internet.uuid,
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          image: Faker::Internet.url
        },
        extra: { raw_info: { profile_image_url_https: Faker::Internet.url } }
      )
    end

    context "when user already exists" do
      before { create(:user, provider: auth.provider, uid: auth.uid) }

      it { is_expected.to be_success }

      it "doesn`t create a new user" do
        expect { result }.not_to change(User, :count)
      end

      it "updates existing user with new info" do
        result

        expect(result.user.reload.attributes).to include(
          "email" => auth.info.email,
          "name" => auth.info.name,
          "profile_image_url" => auth.extra.raw_info.profile_image_url_https
        )
      end
    end

    context "when is a new user" do
      it { is_expected.to be_success }

      it "creates a new user" do
        expect { result }.to change(User, :count).by(1)
      end

      it "updates existing user with new info" do
        result

        expect(result.user.reload.attributes).to include(
          "email" => auth.info.email,
          "name" => auth.info.name,
          "profile_image_url" => auth.extra.raw_info.profile_image_url_https
        )
      end
    end

    context "when auth attributes is invalid" do
      before { auth.uid = nil }

      it { is_expected.to be_failure }
    end
  end
end
