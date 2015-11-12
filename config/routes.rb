Christianrails::Application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :downloads,     only:   [:create]
  resources :purchases,     only:   [:index, :create]
  resources :releases,      except: [:show, :new, :edit, :index]
  resources :price_combos,  except: [:show]
  resources :products,      except: [:show]
  
  root 'main#index'
  get '/admin', to: 'main#admin'
  get '/store', to: 'main#store'

  #get '/downloads', to: 'downloads#test'

end
