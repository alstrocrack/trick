class UserAccount < ApplicationRecord
  MAX_REGISTER_REQUESTS = 5

  def is_exceed?
    requests = Request.where(user_id: self)
    return requests.size >= MAX_REGISTER_REQUESTS
  end
end
