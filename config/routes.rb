Rails.application.routes.draw do
  post "/home/add", controller: :home, action: :add
  post "/api/index", controller: :api, action: :index
  get "/api/index", controller: :api, action: :index
  get "login", controller: :login, action: :index
  root to: "home#index"
end
