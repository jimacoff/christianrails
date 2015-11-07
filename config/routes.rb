Christianrails::Application.routes.draw do
  root 'main#index'

  get '/downloads', to: 'downloads#test'

end
