Rails.application.routes.draw do
  # home
  post "/home/add", controller: :home, action: :add
  delete "/home/delete", controller: :home, action: :delete

  # login
  get "/login", controller: :login, action: :index
  post "/login", controller: :login, action: :authenticate
  delete "/logout", controller: :login, action: :logout

  # register
  get "/register", controller: :register, action: :index
  post "/register", controller: :register, action: :register

  # api
  namespace :api do
    get "/:user/:request_name", controller: :api, action: :get
    match "/(*path)", controller: :options_request, action: :response_preflight_request, via: :options
    match "/(*path)", controller: :api, action: :ng_request, constraints: { path: /.*/ }, via: %i[get post delete]
  end

  # root
  root to: "home#index"
end
