class UserSession < ApplicationRecord
  def authenticate?(token)
    BCrypt::Password.new(session_digest).is_password?(token)
  end
end
