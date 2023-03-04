Rails.application.routes.draw do
  resources :tags
  resources :entries
  post '/filtered_entries', to: 'entries#filtered_index'
  get '/export/entries', to: 'entries#export'

  resources :categories do
    delete 'remove', on: :member
  end
  get '/merge_categories', to: 'categories#merge_form'
  post '/merge_categories', to: 'categories#merge'

  # Dashboard
  get '/dashboard', to: 'dashboards#show'
  post '/dashboard', to: 'dashboards#show'
  post '/turbo_charts/:chart_name', to: 'dashboards#charts', as: 'chart'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'entries#new', as: :authenticated_root
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  if Rails.configuration.database_configuration[Rails.env]['database'] == 'sum_test'
    get '/clear_db', to: 'test#clear_db'
  end
end
