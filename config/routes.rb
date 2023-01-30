Rails.application.routes.draw do
  # home
  post "/home/add", controller: :home, action: :add

  post "/api/index", controller: :api, action: :index
  get "/api/index", controller: :api, action: :index

  # login
  get "/login", controller: :login, action: :index
  post "/login", controller: :login, action: :authenticate
  delete "/logout", controller: :login, action: :logout

  # root
  root to: "home#index"
end
