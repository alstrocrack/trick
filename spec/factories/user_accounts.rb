require "digest"

FactoryBot.define do
  factory :user_account do
    sequence(:email) { |n| "example#{n}@example.com" }
    name { "example_user" }
    password_hash { Digest::SHA256.hexdigest("password") }
  end
end
