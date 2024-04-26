Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :programs, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get '/adminIndex', action: :adminIndex
        end
      end
      resources :schools, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get '/adminIndex', action: :adminIndex
          get '/indexprivate', action: :indexprivate
        end
      end
      resources :schedules, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get '/getAdminAll', action: :getAdminAll
          get '/adminIndex', action: :adminIndex
          get '/indexprivate', action: :indexprivate
        end
      end
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get '/adminIndex', action: :adminIndex
        end
      end
      resources :students, only: [:index, :show, :create, :update, :destroy]
      resources :waitlists, only: [:index, :create]
      resources :carts, only: [:index, :show, :create, :update, :destroy] do
        collection do
          delete '/clearCart', action: :clearCart
        end
      end
      resources :candidates, only: [:index,:create, :destroy]
      resources :purchaseds, only: [:index,:create] do
        collection do
          get 'getStudentInfoSchedule/:schedule_id', action: :getStudentInfoSchedule
          get 'getStudentInfoProduct/:product_id', action: :getStudentInfoProduct
        end
      end
      get '/getall', to: 'schedules#getall'
      get '/getCartSummary', to: 'carts#getCartSummary'
      post '/checkout', to: 'purchaseds#checkout'
      namespace :auth do
        get '/current_user', to: 'current_user#index'
      end
    end
  end
  devise_for :users, path: 'api/v1/auth',path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'api/v1/auth/sessions',
    registrations: 'api/v1/auth/registrations'
  }
  devise_scope :user do
    post "api/v1/auth/createAdmin", to: "api/v1/auth/registrations#createAdmin"
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  post '/checkout', to: 'checkouts#create', as: :create_checkout
  get '/checkout-session-status', to: 'checkouts#session_status', as: :checkout_session_status


  post 'stripe_webhooks', to: 'stripe_webhooks#create'



  # Defines the root path route ("/")
  # root "posts#index"
end
