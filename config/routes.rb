Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#home'
  # Defines the named routes for the static pages
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Defines the named routes for the user controller
  get '/signup', to: 'users#new'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/microposts', to: 'static_pages#home'

  # ユーザーのURLを生成するための名前付きルーティング
  # RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになる
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
  resources :microposts,          only: %i[create destroy]
  resources :relationships,       only: %i[create destroy]
end
