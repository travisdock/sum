Rails.application.routes.draw do
  resources :entries
  get '/export/entries', to: 'entries#export'
  get '/dashboard', to: 'entries#dashboard'
  post '/dashboard', to: 'entries#dashboard'
  resources :categories do
    delete 'remove', on: :member
  end
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'entries#index', as: :authenticated_root
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
