Christianrails::Application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :staged_purchases,     only:   [:index, :create, :destroy]
  resources :purchases,            only:   [:index]
  resources :orders,               only:   [:index]
  resources :releases,             except: [:index, :show, :new, :edit, ]
  resources :price_combos,         except: [:show]
  resources :products,             except: [:show]

  resources :policies, only: [] do
    collection do
      get 'terms_of_use'
      get 'privacy'
      get 'customer_service'
      get 'refund'
    end
  end
  
  resources :store, only: [:index] do
    collection do
      get  'admin'
      get  'updated_prices'
      post 'check_out'
      get  'complete_order'
      post 'download'
    end
  end
  
  get '/admin', to: 'store#admin'
  get '/complete_order', to: 'store#complete_order'

  root 'store#index'

end
