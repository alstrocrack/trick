FactoryBot.define do
  factory :user_session do
    session_digest { BCrypt::Password.create("exmaple-session-value") }
    status { UserSessionStatus::Enable }
    expired_at { nil }
    sequence(:user_id) { |n| n }
  end
end
