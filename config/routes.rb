Christianrails::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :staged_purchases,     only:   [:index, :create, :destroy]
  resources :purchases,            only:   [:index]
  resources :price_combos,         except: [:show]

  resources :products, except: [:show] do
    collection do
      get 'downloads'
    end
    resources :releases, except: [:show]
  end

  resources :orders, only: [:index, :show] do
    collection do
      get 'receipts'
    end
  end

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
      get  'order_success'
    end
  end

  get '/admin', to: 'store#admin'
  get '/complete_order', to: 'store#complete_order'
  get '/order_success',  to: 'store#order_success'

  get '/user_report', to: 'purchases#user_report'

  root 'store#index'

end
