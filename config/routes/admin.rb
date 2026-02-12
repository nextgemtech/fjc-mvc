# frozen_string_literal: true

authenticate :user, -> { _1.admin? } do
  namespace :admin do
    get '/', to: redirect('/admin/dashboard')
    resources :dashboard, only: [:index]
    resources :users, only: %i[index]
    resources :orders, only: %i[index show destroy] do
      member do
        post :ship
        post :recieve
        post :complete
        post :return
        post :refund
        patch :update_shipping_details
        patch :update_logistic_details
        patch :update_return_reason
        patch :update_refund_reason
        patch :update_internal_note
        delete :cancel
      end
    end

    ## product routes
    resources :products do
      resources :variants, except: [:edit], module: :products do
        member do
          patch :position
        end
      end
      resources :stocks, only: %i[index update], module: :products do
        member do
          put :modify
        end
      end
      resources :images, except: %i[edit new], module: :products do
        collection do
          post :upload
        end
        member do
          patch :position
        end
      end
      collection do
        resources :categories
      end
      collection do
        resources :options, only: [:index]
      end
    end

    resources :product_option_values, only: [:create]
  end
end
