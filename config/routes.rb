Rails.application.routes.draw do
  # home
  resources :home, only: %i[create destroy]

  # login
  resources :login, only: %i[index create] do
    collection { delete :destroy, as: "logout" }
  end

  # register
  resources :register, only: %i[index create]

  # user
  resources :users, only: :show

  # api
  namespace :api do
    get "/:user/:request_name", controller: :api, action: :get
    match "/(*path)", controller: :options_request, action: :response_preflight_request, via: :options # for prefilight request
    match "/(*path)", controller: :api, action: :ng_request, constraints: { path: /.*/ }, via: %i[get post delete]
  end

  # root
  root to: "home#index"
end
