Christianrails::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :staged_purchases,     only:   [:index, :create, :destroy]
  resources :purchases,            only:   [:index]
  resources :price_combos,         except: [:show]

  resources :users, only: [:show, :edit]

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
      get  'updated_prices'
      post 'check_out'
      get  'complete_order'
      post 'download'
      get  'order_success'
    end
  end

  resources :admin, only: [:index]

  namespace :woods do
    resources :players

    resources :stories, except: [:delete] do
      member do
        get 'play'
        get 'move_to'
        get 'manage'
      end
      resources :storytrees, only: [:show]
    end

    resources :itemsets do
      resources :items, only: [] do
        post 'download'
      end
    end

  #   resources :palettes
  #   resources :treelinks
  #   resources :possibleitems
  #   resources :paintballs
  #   resources :boxes
  end

  get '/woods',          to: 'woods/stories#index'

  get '/complete_order', to: 'store#complete_order'
  get '/order_success',  to: 'store#order_success'

  get '/user_report',    to: 'purchases#user_report'

  root 'store#index'

  %w( 404 422 500 ).each do |code|
    get code, to: "errors#show", code: code
  end

end
