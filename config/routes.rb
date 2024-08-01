Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
  # Defines the named routes for the static pages
  get "/help",    to: "static_pages#help"
  get "/about",   to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
end
