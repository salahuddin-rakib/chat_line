class Message < ApplicationRecord
  belongs_to :from_user, polymorphic: true
  belongs_to :to_user, polymorphic: true

  enum read_state: { unread: 0, read: 1 }
end
