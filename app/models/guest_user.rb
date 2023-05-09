class GuestUser
  def initialize(session_value)
    return UserSession.find_by(value: guest_session, status: UserSessionStatus::Temporary)
  end

  def is_exceed?
    return Request.where(guest_id: self.id).count >= RequestCounts::Max
  end
end
