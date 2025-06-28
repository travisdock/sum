Rails.application.routes.draw do
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

  # Vanilla authentication routes
  resources :users, only: [:new, :create, :show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :show, :update], param: :token
  
  # Root routes
  authenticated_root = proc { |request| request.session[:user_id].present? }
  constraints(authenticated_root) do
    root 'entries#new', as: :authenticated_root
  end
  
  root 'sessions#new', as: :unauthenticated_root
  
  # Convenience routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  if Rails.configuration.database_configuration[Rails.env]['database'] == 'storage/test.sqlite3'
    get '/clear_db', to: 'test#clear_db'
  end
end
