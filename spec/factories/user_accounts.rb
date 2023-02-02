FactoryBot.define do
  factory :user_account do
    sequence(:email) { |n| "example#{n}@example.com" }
    password_hash { "password" }
    endpoint_value { "my_endpoint" }
  end
end
