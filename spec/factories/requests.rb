FactoryBot.define do
  factory :request do
    user_id { 1 }
    name { "trick" }
    status_code { 200 }
    response_header { { text: "text" } }
    response_body { { text: "text" } }
  end
end
