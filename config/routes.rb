Rails.application.routes.draw do
  resources :entries
  post '/filtered_entries', to: 'entries#filtered_index'
  get '/export/entries', to: 'entries#export'
  resources :categories do
    delete 'remove', on: :member
  end

  # Dashboard
  get '/dashboard', to: 'dashboards#show'
  post '/dashboard', to: 'dashboards#show'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'entries#new', as: :authenticated_root
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
