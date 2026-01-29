require "sidekiq/web"

Rails.application.routes.draw do
  get "/health", to: "health#show"

  # NOTE:
  # The Sidekiq Web UI should NOT be mounted without authentication in production.
  # Otherwise, anyone can see job queues, retries, and internal data.
  #
  # We now protect it using Devise authentication and allow access ONLY to admin users.
  #
  # If you want even stricter protection, you can also add HTTP Basic Auth or IP whitelisting.
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

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
