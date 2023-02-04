require "digest"

FactoryBot.define do
  factory :user_account do
    sequence(:email) { |n| "example#{n}@example.com" }
    password_hash { Digest::SHA256.hexdigest("password") }
    endpoint_value { "my_endpoint" }
  end
end
