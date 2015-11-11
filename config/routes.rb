Christianrails::Application.routes.draw do
  devise_for :users

  resources :downloads,     only:   [:create]
  resources :purchases,     only:   [:index, :create]
  resources :releases,      except: [:show, :new, :edit, :index]
  resources :price_combos,  except: [:show]
  resources :products,      except: [:show]
  
  root 'main#index'
  get '/admin', to: 'main#admin'

  #get '/downloads', to: 'downloads#test'

end
