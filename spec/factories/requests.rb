FactoryBot.define do
  factory :request do
    sequence(:name) { |n| "trick#{n}" }
    status_code { 200 }
    response_header { RegisteringRequest.build_registering_request_header("key1", "key2", "key3", "value1", "value2", "value3") }
    response_body { { text: "text" } }
  end
end
