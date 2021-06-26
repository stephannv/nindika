# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    %i[twitter discord].each do |provider|
      define_method provider do
        result = Users::GetFromOmniauth.result(auth: request.env['omniauth.auth'])

        if result.success?
          sign_in_and_redirect result.user, event: :authentication
          flash[:success] = t('.success', user: result.user.name) if is_navigational_format?
        else
          flash[:danger] = t('.error')
          redirect_to root_path
        end
      end
    end

    # :nocov:
    def failure
      redirect_to root_path, danger: t('.error')
    end
    # :nocov:
  end
end
