# frozen_string_literal: true

root 'home#index'

resources :products, only: %i[index show]
resources :pilipinas, param: :name, only: %i[] do
  member do
    get :cities
    get :barangays
  end
end
resources :checkouts, path: :checkout, only: :show do
  member do
    post :shipping_details
    post :payment_method
  end
end

resources :carts, only: %i[index update destroy] do
  collection do
    get :total
    get :count
    post :sync_all
    post :proceed_checkout
    delete :bulk_delete
  end
  member do
    get :variant_dropdown
    post :sync
  end
end

resources :variants, only: [] do
  member do
    get :info
    post :add_to_cart
    post :guest_add_to_cart
    post :buy_now
    post :guest_buy_now
  end
end

resource :account, only: :show
resources :orders, only: %i[index show] do
  member do
    post :sync
    delete :cancel
  end
end

# error routes
match "/404", to: "errors#not_found", via: :all
match "/500", to: "errors#internal_server_error", via: :all
match "*path", to: "errors#not_found", via: :all, constraints: lambda { |req|
  !req.path.starts_with?("/rails/active_storage")
}
