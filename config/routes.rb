Rails.application.routes.draw do
  get 'user/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#home'
  # Defines the named routes for the static pages
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Defines the named routes for the user controller
  get '/signup', to: 'user#new'

  # ユーザーのURLを生成するための名前付きルーティング
  # RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになる
  resources :user
end
