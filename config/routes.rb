Christianrails::Application.routes.draw do
  devise_for :users

  resources :downloads,     only:   [:index, :create]
  resources :releases,      except: [:show, :new, :edit]
  resources :purchases,     except: [:show, :new, :edit]
  resources :price_combos,  except: [:show]
  resources :products,      except: [:show]
  
  root 'main#index'

  #get '/downloads', to: 'downloads#test'

end
