require "digest"

class UserAccount < ApplicationRecord
  def is_exceed?
    requests = Request.where(user_id: self)
    return requests.size >= RequestCounts::Max
  end

  def authenticate?(password)
    password_hash = Digest::SHA256.hexdigest(password.strip)
    return self.password_hash == password_hash
  end

  # NOTE: Mainly used for request registration inside applications, etc
  def get_api_key
    return ApiKey.find_by(owner_id: ApiKey.get_user_api_key(self.id)).value
  end

  # NOTE: Mainly used to respond to API inquiries
  def self.get_api_key(user)
    owner_id = ApiKey.get_user_api_key(UserAccount.find_by(name: user).id)
    return ApiKey.find_by(owner_id: owner_id).value
  end
end
