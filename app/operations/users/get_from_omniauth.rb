# frozen_string_literal: true

module Users
  class GetFromOmniauth < Actor
    input :auth, type: OmniAuth::AuthHash

    output :user, type: User

    def call
      user = User.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
      user.assign_attributes(user_attributes)
      fail!(error: :invalid_user) unless user.save

      self.user = user
    end

    private

    def user_attributes
      profile_image_url = auth.dig(:extra, :raw_info, :profile_image_url_https) || auth.info.image
      {
        email: auth.info.email,
        name: auth.info.name,
        profile_image_url: profile_image_url
      }
    end
  end
end
