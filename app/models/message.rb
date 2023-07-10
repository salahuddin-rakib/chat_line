class Message < ApplicationRecord
  belongs_to :from_user, polymorphic: true
  belongs_to :to_user, polymorphic: true
end
