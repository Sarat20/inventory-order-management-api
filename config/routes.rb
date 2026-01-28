require "sidekiq/web"

Rails.application.routes.draw do
  get "/health", to: "health#show"
  # NOTE: The Sidekiq Web UI is mounted without authentication. In production, this would expose
  # job queues, retry functionality, and potentially sensitive data. Consider adding authentication
  # (e.g., Devise or HTTP Basic) before deployment.
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :products
      resources :categories
      resources :suppliers
      resources :customers

      resources :orders do
        member do
          post :confirm
          post :ship
          post :cancel
        end
      end

      post   "auth/login",    to: "auth#login"
      post   "auth/register", to: "auth#register"
      delete "auth/logout",   to: "auth#logout"
      get    "auth/me",       to: "auth#me"
   

    end
  end
end
