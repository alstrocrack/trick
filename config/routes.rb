Rails.application.routes.draw do
  post "/home/add_new_request", controller: :home, action: :add_new_request
  post "/api/index", controller: :api, action: :index
  get "/api/index", controller: :api, action: :index
  root to: "home#index"
end
