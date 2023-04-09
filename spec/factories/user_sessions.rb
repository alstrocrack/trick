FactoryBot.define do
  factory :user_session do
    value { "exmaple-session-value" }
    status { UserSessionStatus::Enable }
    expired_at { nil }
    sequence(:user_id) { |n| n }
  end
end
