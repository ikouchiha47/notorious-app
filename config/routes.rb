Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'home#index'
  resources :categories, only: %i[index]
  resources :products, only: %i[show index]

  resources :carts, except: [:new]

  resources :carts do
    collection do
      get "/guest/:token", to: "carts#guest_order", as: 'guest_order'
    end
  end

  resources :checkouts do
    collection {
      post :review

      post "/guest/buy", to: "checkouts#guest_buy"
    }
  end

end
