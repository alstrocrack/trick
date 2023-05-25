FactoryBot.define do
  factory :request do
    name { "trick" }
    key1 { "X-aaa-key" }
    value1 { "abcdef" }
    status { 200 }
    response_body { { text: "text" } }
  end
end
