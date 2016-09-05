require 'constraints/domain_constraint'
require 'constraints/whitelist'

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

  resources :watch_properties, except: [:show] do
    collection do
      post 'check_properties', constraints: Whitelist.new
    end
  end

  resources :admin, only: [:index] do
    collection do
      get 'emailtest'
      get 'crm_stats'
    end
  end

  namespace :woods do
    resources :players

    resources :stories, except: [:create, :update, :destroy] do
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

    [:treelinks, :paintballs, :possibleitems, :boxes].each do |accoutrement|
      resources accoutrement, only: [] do
        collection do
          post 'upsert'
        end
      end
    end
  end

  resources :newsletter_signups, only: [:index, :create]

  post '/woods/items/download', to: 'woods/items#download'
  get  '/woods',                to: 'woods/stories#index'

  get '/diamondfind',      to: 'woods/stories#show', defaults: { id: 1 }
  get '/diamondfind/play', to: 'woods/stories#play', defaults: { id: 1 }

  namespace :crm do
    resources :assistants, only: [:index, :create, :update] do
      collection do
        get  'settings'
        post 'send_daily_emails', constraints: Whitelist.new
      end
    end
    resources :contacts, except: [:show]
    resources :obligations, except: [:show] do
      collection do
        get 'closed'
      end
      member do
        post 'complete'
        post 'bypass'
      end
    end
    resources :tasks, except: [:show] do
      collection do
        get 'closed'
      end
      member do
        post 'complete'
        post 'bypass'
      end
    end
    resources :meetings, except: [:show] do
      collection do
        get 'past'
      end
      member do
        post 'complete'
        post 'bypass'
      end
    end
    resources :ideas, except: [:show] do
      collection do
        get 'closed'
      end
      member do
        post 'complete'
        post 'abandon'
      end
    end
    resources :books, except: [:show] do
      collection do
        get 'have_read'
      end
      member do
        post 'start_reading'
        post 'finish'
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
