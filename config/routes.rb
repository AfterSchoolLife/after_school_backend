Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :programs, only: [:index, :show, :create, :update, :destroy]
      resources :schools, only: [:index, :show, :create, :update, :destroy]
      resources :schedules, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :students, only: [:index, :show, :create, :update, :destroy]
      resources :carts, only: [:index, :show, :create, :update, :destroy]
      get '/getall', to: 'schedules#getall'
      get '/getSchedules', to: 'schedules#getSchedules'
      get '/getCartSummary', to: 'carts#getCartSummary'
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
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
