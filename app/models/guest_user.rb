class GuestUser
  attr_reader :id

  def initialize(session_value)
    @id = UserSession.find_by(value: session_value, status: UserSessionStatus::Temporary).id
  end

  def is_exceed?
    return Request.where(guest_id: self.id).count >= RequestCounts::Max
  end

  def get_api_key
    return ApiKey.find_by(owner_id: ApiKey.get_guest_api_key(@id)).value
  end
end
