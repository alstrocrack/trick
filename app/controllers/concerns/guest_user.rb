require "active_support/concern"

module GuestUser
  extend ActiveSupport::Concern

  def self.get_guest_user_id(guest_session)
    return UserSession.find_by(value: guest_session, status: UserSessionStatus::Temporary).id
  end

  def self.get_requests(guest_session_id)
    return Request.where(guest_id: guest_session_id)
  end

  def self.is_exceed?(guest_session_id)
    return self.get_requests(guest_session_id).count > RequestCounts::Max
  end
end
