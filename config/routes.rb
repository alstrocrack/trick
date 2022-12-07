Rails.application.routes.draw do
  post "/home/add_new_request", controller: :home, action: :add_new_request
  root to: "home#index"
end
