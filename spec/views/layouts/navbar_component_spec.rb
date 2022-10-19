# frozen_string_literal: true

require "rails_helper"

RSpec.describe Layouts::NavbarComponent, type: :view do
  it "renders navbar title" do
    result = render_view(described_class.new(title: "Some title", current_user: nil))

    expect(result.css(".navbar span")).to have_text "Some title"
  end

  context "with current user" do
    it "doesn't render sign in button" do
      user = build_stubbed :user

      result = render_view(described_class.new(title: "Some title", current_user: user))

      expect(result).not_to have_link I18n.t("layouts.navbar_component.sign_in")
    end
  end

  context "without current user" do
    it "renders sign in button" do
      result = render_view(described_class.new(title: "Some title", current_user: nil))

      expect(result).to have_link I18n.t("layouts.navbar_component.sign_in"), href: new_user_session_path
    end
  end
end
