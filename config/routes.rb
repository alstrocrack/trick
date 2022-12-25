Rails.application.routes.draw do
  # home
  post "/home/add", controller: :home, action: :add

  post "/api/index", controller: :api, action: :index
  get "/api/index", controller: :api, action: :index

  # login
  get "/login", controller: :login, action: :index
  post "/login", controlle: :login, action: :authenticate

  # root
  root to: "home#index"
end
