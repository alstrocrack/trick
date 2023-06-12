class GuestUser
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def is_exceed?
    return Request.where(guest_id: self.id).count >= RequestCounts::Max
  end

  # NOTE: Mainly used for request registration inside applications, etc
  def get_api_key
    return ApiKey.find_by(owner_id: ApiKey.get_guest_api_key(@id)).value
  end

  # NOTE: Mainly used to respond to API inquiries
  def self.get_api_key(id)
    return ApiKey.find_by(owner_id: ApiKey.get_guest_api_key(id)).value
  end
end
