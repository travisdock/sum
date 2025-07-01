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

  # Charts
  get '/charts', to: 'charts#index'

  get '/charts/profit_loss', to: 'charts#profit_loss'
  get '/charts/pie_chart', to: 'charts#pie_chart'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'entries#new', as: :authenticated_root
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  if Rails.configuration.database_configuration[Rails.env]['database'] == 'storage/test.sqlite3'
    get '/clear_db', to: 'test#clear_db'
  end
end
