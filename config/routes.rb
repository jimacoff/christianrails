Christianrails::Application.routes.draw do
  devise_for :users
  root 'main#index'

  #get '/downloads', to: 'downloads#test'

end
