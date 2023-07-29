Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'home#index'
  resources :categories, only: %i[index]
  resources :products, only: %i[show index]

  resources :carts, except: [:new]

  # get '/peppermint.js', to: 'home#peppermint_spray', format: 'js'

end
