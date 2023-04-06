Rails.application.routes.draw do
  # home
  post "/home/add", controller: :home, action: :add

  # login
  get "/login", controller: :login, action: :index
  post "/login", controller: :login, action: :authenticate
  delete "/logout", controller: :login, action: :logout

  # register
  get "/register", controller: :register, action: :index
  post "/register", controller: :register, action: :register

  # api
  post "/api/:email", controller: :api, action: :index
  get "/api/:email", controller: :api, action: :index

  # root
  root to: "home#index"
end
