require "digest"

class UserAccount < ApplicationRecord
  def is_exceed?
    requests = Request.where(user_id: self)
    return requests.size >= RequestCounts::Max
  end

  def authenticate?(password)
    password_hash = Digest::SHA256.hexdigest(password.strip)
    self.password_hash == password_hash
  end
end
