# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resource :cart
  resource :wishlist
  resource :saleline_item
  resources :products do
    get :dashboard, on: :collection
    resources :comments
  end
end
