Christianrails::Application.routes.draw do
  resources :combo_items
  resources :price_combos
  resources :downloads
  resources :releases
  resources :products
  devise_for :users
  root 'main#index'

  #get '/downloads', to: 'downloads#test'

end
