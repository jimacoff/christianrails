require 'constraints/domain_constraint'

Christianrails::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show]

  resources :blog, only: [:index] do
    collection do
      get 'show_post'
      get 'archives'
      get 'category'
      get 'tag'
    end
  end

  resources :staged_purchases,     only:   [:index, :create, :destroy]
  resources :price_combos,         except: [:show]

  resources :purchases,            only:   [:index]
  get '/user_report',              to: 'purchases#user_report'

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

  resources :store, only: [:index] do
    collection do
      get  'updated_prices'
      post 'check_out'
      get  'complete_order'
      post 'download'
      get  'order_success'
    end
  end
  get '/complete_order', to: 'store#complete_order'
  get '/order_success',  to: 'store#order_success'


  resources :policies, only: [] do
    collection do
      get 'terms_of_use'
      get 'privacy'
      get 'customer_service'
      get 'refund'
    end
  end

  resources :admin, only: [:index] do
    collection do
      get 'emailtest'
    end
  end

  namespace :woods do
    resources :players

    resources :stories, except: [:delete] do
      member do
        get 'play'
        get 'move_to'
        get 'manage'
      end

      resources :storytrees, only: [:show] do
        resources :nodes, only: [:update]
      end

      resources :palettes
      resources :itemsets do
        resources :items, only: [:create, :update, :destroy] do
          post 'download'
        end
      end
    end
  end

  post '/woods/items/download', to: 'woods/items#download'
  get  '/woods',                to: 'woods/stories#index'

  get '/diamondfind',      to: 'woods/stories#show', defaults: { id: 1 }
  get '/diamondfind/play', to: 'woods/stories#play', defaults: { id: 1 }

  namespace :crm do
    resources :obligations, except: [:show]
    resources :assistants, only: [:index]
    resources :contacts, except: [:show] do
      collection do
        post 'newsletter_signup'
      end
    end
  end
  get '/crm', to: 'crm/assistants#index'

  resources :graveyard, only: [] do
    collection do
      get 'fractalfic'
    end
  end
  get '/fractalfic', to: 'graveyard#fractalfic'

  get '/butler',               to: 'butler#index'
  get '/butler/show_post',     to: 'butler#show_post'
  get '/butler/category',      to: 'butler#category'
  get '/butler/tag',           to: 'butler#tag'

  get '/', to: 'graveyard#fractalfic', constraints: DomainConstraint.new('fractalfic.com')
  get '/', to: 'butler#index',         constraints: DomainConstraint.new('wolfbutler.com')
  root 'store#index'

  get 'page_not_found', to: "errors#show", code: '404'
  %w( 404 422 500 ).each do |code|
    get code, to: "errors#show", code: code
  end

end
