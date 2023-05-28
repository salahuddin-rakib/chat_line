class User < ApplicationRecord
  # Adding password encryption using Bcrypt
  has_secure_password

  #Associations:
  has_many :messages, as: :from_user, class: 'Message'
  has_many :messages, as: :to_user, class: 'Message'

  # Validations:
  validates :full_name, presence: true
  validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i

  enum user_type: { customer: 0, admin: 1 }
  enum status: { active: 0, inactive: 1 }
end
