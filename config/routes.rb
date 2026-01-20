Rails.application.routes.draw do
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
    end
  end
end
