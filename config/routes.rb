require 'constraints/domain_constraint'

Christianrails::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', invitations: 'invitations' }

  resources :users, only: [:show, :update] do
    collection do
      get 'report'
      post 'consume'
      delete 'consume'
    end
    member do
      get 'settings'
      post 'follow_up_about_product'
      post 'block'
    end
  end
  resources :logs, only: [:index]
  resources :policies, only: [] do
    collection do
      get 'terms_of_use'
      get 'privacy'
      get 'customer_service'
      get 'refund'
    end
  end
  resources :watch_properties, except: [:show]
  resources :newsletter_signups, only: [:index, :create]
  resources :admin, only: [:index] do
    collection do
      get 'emailtest'
      get 'receipttest'
      get 'crm_stats'
      get 'cause_exception'
    end
  end


###### THE STORE #######

  namespace :store do
    resources :dealzone, only: [:index] do
      collection do
        get  'cart'
        get  'library'
        get  'memberships'
        get  'updated_prices'
        post 'check_out'
        get  'complete_order'
        get  'order_success'
        post 'download'
        post 'open_book'
      end
    end

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
    resources :digital_purchases,    only:   [:index]
    resources :physical_purchases,   only:   [:index]

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

    resources :free_gifts, only: [:index, :new, :create] do
      member do
        post 'give'
      end
    end
  end
  get '/complete_order', to: 'store/dealzone#complete_order'
  get '/order_success',  to: 'store/dealzone#order_success'
  get '/store',          to: 'store/dealzone#index'
  get '/cart',           to: 'store/dealzone#cart'
  get '/memberships',    to: 'store/dealzone#memberships'
  # get '/gifts/',         to: 'store/dealzone#gifts'
  get '/library/',       to: 'store/dealzone#library'

  # store product pages
  get '/ghostcrime',  to: 'store/ghostcrime#index'
  get '/snapback',    to: 'store/snapback#fuseki'
  get '/snapback-1',  to: 'store/snapback#fuseki'
  get '/snapback-2',  to: 'store/snapback#shimari'
  get '/snapback-fuseki',  to: 'store/snapback#fuseki'
  get '/snapback-shimari', to: 'store/snapback#shimari'

######## BINARYWOODS ###########

  namespace :woods do
    resources :players

    resources :stories, except: [:destroy] do
      member do
        get 'play'
        get 'move_to'
        get 'manage'
        get 'export'
        get 'item_tester'
      end

      resources :storytrees, only: [:show, :create] do
        member do
          get 'stats'
        end
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

    resources :sync, only: [] do
      collection do
        get 'find_node_by_desc'
      end
    end
  end
  post '/woods/items/download', to: 'woods/items#download'
  get  '/woods',                to: 'woods/stories#index'

  get  '/diamondfind',          to: 'woods/stories#diamondfind'
  get  '/diamondfind/play',     to: 'woods/stories#play', defaults: { id: 1 }

  get  '/thecalicobrief',       to: 'woods/stories#thecalicobrief'
  get  '/calicobrief',          to: 'woods/stories#thecalicobrief'
  get  '/thecalicobrief/play',  to: 'woods/stories#play', defaults: { id: 15 }
  get  '/calicobrief/play',     to: 'woods/stories#play', defaults: { id: 15 }

######## GHOSTCRM ##############

  namespace :crm do
    resources :assistants, only: [:index, :create, :update] do
      collection do
        get 'settings'
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
  get '/crm',      to: 'crm/assistants#index'
  get '/ghostcrm', to: 'crm/assistants#index'


###### GO STUFF AND DIVERSIONS #######

  resources :diversions, only: [:index] do
    collection do
      get 'rainfield'
      get 'stocks'
    end
  end
  get '/go',  to: 'go#index'


##### BUTLER STUFF ######

  get '/wolfbutler',       to: 'butler#index'
  get '/butler',           to: 'butler#index'
  get '/butler/about',     to: 'butler#about'
  get '/butler/archives',  to: 'butler#archives'
  get '/butler/show_post', to: 'butler#show_post'
  get '/butler/category',  to: 'butler#category'
  get '/butler/tag',       to: 'butler#tag'


####### BADGER STUFF ######

  resources :badger, only: [:index] do  # badger doesn't have categories
    collection do
      get 'read'
      get 'show_post'
      get 'archives'
      get 'tag'
    end
  end
  get '/thisbadger', to: 'badger#index'
  get '/badger',     to: 'badger#index'


###### SCALEQUAIL STUFF ######

  resources :scalequail, only: [:index] do
    collection do
      get 'show_post'
      get 'archives'
      get 'category'
      get 'tag'
    end
  end
  get '/scalequail', to: 'scalequail#index'


####### COMPUTER BLOG STUFF ######

  resources :computers, only: [:index] do
    collection do
      get 'show_post'
      get 'archives'
      get 'category'
      get 'tag'
    end
  end
  get '/computers', to: 'computers#index'


###### MELON STUFF ######

  resources :melon, only: [:index, :create] do
    collection do
      get 'stats'
    end
  end
  get '/melon', to: 'melon#index'
  get '/m3lon', to: 'melon#index'

###### GRAVEYARD #######

  resources :graveyard, only: [:index] do
    collection do
      get 'fractalfic'
      get 'gray'
      get 'reserve'
      get 'silverstock'
      get 'blackink'
    end
  end
  get '/fractalfic',  to: 'graveyard#fractalfic'
  get '/gray',        to: 'graveyard#gray'
  get '/reserve',     to: 'graveyard#reserve'
  get '/silverstock', to: 'graveyard#silverstock'
  get '/blackink',    to: 'graveyard#blackink'



####### ROOTS & ERRORS ##########

  get '/', to: 'graveyard#fractalfic',                     constraints: DomainConstraint.new('fractalfic.com')
  get '/', to: 'butler#index',                             constraints: DomainConstraint.new('wolfbutler.com')
  get '/', to: 'woods/stories#show', defaults: { id: 1 },  constraints: DomainConstraint.new('diamondfind.ca')
  get '/', to: 'badger#index',                             constraints: DomainConstraint.new('thisbadger.com')
  get '/', to: 'store/ghostcrime#index',                   constraints: DomainConstraint.new('ghostcrime.com')
  get '/', to: 'crm/assistants#index',                     constraints: DomainConstraint.new('ghostcrm.ca')
  get '/', to: 'scalequail#index',                         constraints: DomainConstraint.new('scalequail.com')
  get '/', to: 'store/dealzone#index',                     constraints: DomainConstraint.new('christiandewolfe.com')
  get '/', to: 'melon#index',                              constraints: DomainConstraint.new('m3lon.com')
  root 'store/dealzone#index'

  get 'page_not_found', to: "errors#show", code: '404'
  %w( 404 422 500 ).each do |code|
    get code, to: "errors#show", code: code
  end

end
