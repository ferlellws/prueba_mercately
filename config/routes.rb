Rails.application.routes.draw do
  resources :products do
    post 'add_to_cart', on: :member
  end

  resources :orders, only: [:index, :show, :destroy, :add] do
    member do
      post :add
      post :add_from_input
      post :decrease
      put :checkout
    end
  end
  get 'cart/:id', to: 'orders#show', as: :cart

  resources :order_items

  root 'products#index'
end
