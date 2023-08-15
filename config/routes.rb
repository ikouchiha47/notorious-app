Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'home#index'

  get '/accounts', to: 'accounts#show'
  post '/accounts/login', to: 'accounts#login'
  post '/accounts/signup', to: 'accounts#signup'
  delete '/accounts/logout', to: 'accounts#logout'

  patch '/accounts/recover', to: 'accounts#trigger_recover_password'
  get '/accounts/recover', to: 'accounts#validate_recovery_token'
  patch '/accounts/reset/password', to: 'accounts#reset_password'

  resources :categories, only: %i[index]
  resources :products, only: %i[show index]

  resources :carts, except: [:new]

  resources :carts do
    collection do
      get '/guest/:token', to: 'carts#guest_order', as: 'guest_order'
    end
  end

  resources :checkouts do
    collection do
      post :review

      post '/guest/buy', to: 'checkouts#guest_buy'
    end
  end

  match '*unmatched', to: 'application#not_found_method', via: :all
end
