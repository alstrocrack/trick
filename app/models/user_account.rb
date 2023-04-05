require "digest"

class UserAccount < ApplicationRecord
  MAX_REGISTER_REQUESTS = 5

  def is_exceed?
    requests = Request.where(user_id: self)
    return requests.size >= MAX_REGISTER_REQUESTS
  end

  def authenticate?(password)
    password_hash = Digest::SHA256.hexdigest(password.strip)
    self.password_hash == password_hash
  end
end
