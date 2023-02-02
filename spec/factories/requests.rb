FactoryBot.define do
  factory :request do
    user_id { 1 }
    from_address { "198.1.1.1" }
    status_code { 200 }
    response_header { { text: "text" } }
    response_body { { text: "text" } }
  end
end
