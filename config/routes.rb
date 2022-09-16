# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  post :create, to: 'orders#create'
  post :capture_order, to: 'orders#capture_order'
  resource :cart, only: %i[show]
  resource :wishlist, only: %i[show update destroy]
  resource :saleline_item, only: %i[create update destroy]
  resource :order, only: %i[show]
  resources :products do
    get :dashboard, on: :collection
    resources :comments, only: %i[create edit update destroy]
  end
end
