class UserSession < ApplicationRecord
  def authenticate?(token)
    return BCrypt::Password.new(self.session_digest).is_password?(token)
  end
end
