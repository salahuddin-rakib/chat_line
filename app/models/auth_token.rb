class AuthToken < ApplicationRecord
  belongs_to :user

  def is_expired?
    expiry.to_i < Time.now.to_i
  end
end
