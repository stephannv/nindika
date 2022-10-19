# frozen_string_literal: true

module Layouts
  class NavbarComponent < ApplicationView
    def initialize(title:, current_user:)
      @title = title
      @current_user = current_user
    end

    def template
      div class: "navbar lg:w-[calc(100%-18rem)] bg-base-200" do
        div class: "w-full flex truncate" do
          label for: "app-drawer", class: "btn btn-ghost btn-circle drawer-button lg:hidden" do
            drawer_button_icon
          end

          span class: "text-2xl font-bold truncate lg:ml-4" do
            title
          end
        end

        div class: "w-auto mr-2" do
          if current_user.present?
            render Layout::UserMenuComponent.new(current_user: current_user)
          else
            a href: new_user_session_path, class: "btn btn-primary" do
              helpers.t(:sign_in, scope: i18n_scope)
            end
          end
        end
      end
    end

    private

    attr_reader :title, :current_user

    def i18n_scope = "layouts.navbar_component"

    def drawer_button_icon
      raw <<~HTML # rubocop:disable Rails/OutputSafety
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      HTML
    end
  end
end
