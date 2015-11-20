Christianrails::Application.routes.draw do
  
  resources :staged_purchases
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :downloads,     only:   [:create]
  resources :purchases,     only:   [:index, :create]
  resources :releases,      except: [:show, :new, :edit, :index]
  resources :price_combos,  except: [:show]
  resources :products,      except: [:show]
  
  resources :store,  only: [:index] do
    collection do
      get 'updated_prices'
      get 'check_out'
    end
  end

  resources :main, only: [] do
    collection do
      get 'store'
    end
  end
  
  root 'main#index'
  get '/admin', to: 'main#admin'
  get '/store', to: 'store#index'

  #get '/downloads', to: 'downloads#test'

end
