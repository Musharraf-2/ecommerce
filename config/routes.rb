# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  get 'carts/add_to_cart/:id', to: 'carts#add_to_cart', as: 'add_to_cart'
  get 'carts/remove_from_cart/:id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
  get 'carts/show', to: 'carts#show', as: 'cart'
  resources :products do
    get :dashboard, on: :collection
    resources :comments
  end
end
