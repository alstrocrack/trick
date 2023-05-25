Rails.application.routes.draw do
  # home
  resources :home, only: %i[create destroy]

  # login
  resources :login do
    member { post :create }
    collection do
      get :index
      delete :destroy
    end
  end

  # register
  get "/register", controller: :register, action: :index
  post "/register", controller: :register, action: :register

  # user
  get "/users/:id", controller: :users, action: :index, as: :user

  # api
  namespace :api do
    get "/:user/:request_name", controller: :api, action: :get
    match "/(*path)", controller: :options_request, action: :response_preflight_request, via: :options # for prefilight request
    match "/(*path)", controller: :api, action: :ng_request, constraints: { path: /.*/ }, via: %i[get post delete]
  end

  # root
  root to: "home#index"
end
