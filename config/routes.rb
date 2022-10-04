# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resource :cart, only: %i[show]
  resource :wishlist, only: %i[show update destroy]
  resource :saleline_item, only: %i[create update destroy]
  resource :order, only: %i[show new create]
  resources :products do
    get :dashboard, on: :collection
    get :search, on: :collection
    resources :comments, only: %i[create edit update destroy]
  end
  namespace :api do
    namespace :v1 do
      resources :products, only: %i[index show]
    end
  end
  match '*path', to: 'application#page_not_found', via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
