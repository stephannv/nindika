# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true

  has_enumeration_for :notification_type,
    with: NotificationTypes,
    create_helpers: true,
    required: true,
    create_scopes: true

  validates :title, presence: true
end
