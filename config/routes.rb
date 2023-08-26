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

  resources :carts, except: %i[new delete] do
  end

  delete '/carts/remove/:id', to: 'carts#remove', as: 'remove_from_cart'

  resources :carts do
    collection do
      get '/guest/:token', to: 'carts#guest_order', as: 'guest_order'
      get '/my/review', to: 'carts#show'
    end
  end

  resources :checkouts do
    collection do
      post '/guest/buy', to: 'checkouts#guest_buy'
      post '/guest', to: 'checkouts#guest_create'

      post '/direct_buy', to: 'checkouts#direct_buy'
      post '/me/buy', to: 'checkouts#create', as: 'place_my_order'
    end
  end

  get '/me/addresses', to: 'addresses#index', as: 'addresses'
  get '/me/addresses/:id', to: 'address#edit', as: 'edit_address'

  # this is an idempotent route, if its update the params[:id] is present?
  # else its a new address for the current_user
  patch '/me/addresses', to: 'addresses#update', as: 'add_address'
  delete '/me/addresses/:id', to: 'addresses#delete', as: 'delete_address'

  match '*unmatched', to: 'application#not_found_method', via: :all
end
