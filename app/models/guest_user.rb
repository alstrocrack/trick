class GuestUser
  attr_reader :id

  def initialize(session_value)
    @id = UserSession.find_by(value: session_value, status: UserSessionStatus::Temporary).id
  end

  def is_exceed?
    return Request.where(guest_id: self.id).count >= RequestCounts::Max
  end
end
