Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :recurrables
  resources :tags
  resources :entries
  post '/filtered_entries', to: 'entries#index'
  get '/export/entries', to: 'entries#export'

  resources :categories do
    delete 'remove', on: :member
  end
  get '/merge_categories', to: 'categories#merge_form'
  post '/merge_categories', to: 'categories#merge'

  # Dashboard
  get '/dashboard', to: 'dashboards#show'
  post '/dashboard', to: 'dashboards#show'

  # Authentication routes
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
  
  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'
  
  resources :users, only: [:edit, :update]
  
  # Root routes
  constraints lambda { |req| req.session[:user_id].present? } do
    root 'entries#new', as: :authenticated_root
  end
  
  root 'sessions#new'

  if Rails.configuration.database_configuration[Rails.env]['database'] == 'storage/test.sqlite3'
    get '/clear_db', to: 'test#clear_db'
  end
end