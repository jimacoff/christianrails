Christianrails::Application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :staged_purchases,     only:   [:index, :create, :destroy]
  resources :purchases,            only:   [:index, :create]
  resources :releases,             except: [:index, :show, :new, :edit, ]
  resources :price_combos,         except: [:show]
  resources :products,             except: [:show]
  
  resources :store, only: [:index] do
    collection do
      get 'admin'
      get 'updated_prices'
      get 'check_out'
      post 'download'
    end
  end
  
  get '/admin', to: 'store#admin'
  
  root 'store#index'

end
