require "securerandom"

class ApiKey < ApplicationRecord
  USER_PREFIX = "user"
  GUEST_PREFIX = "guest"

  def self.issue
    return SecureRandom.uuid
  end

  def self.get_user_api_key(id)
    return USER_PREFIX + "-" + id.to_s
  end
end
