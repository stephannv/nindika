# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[twitter discord]

  validates :provider, presence: true
  validates :uid, presence: true

  validates :uid, uniqueness: { scope: :provider }
end
