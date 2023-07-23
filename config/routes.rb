Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#dashboard'
  get '/repositories', to: 'dashboard#repositories'
  get '/people', to: 'dashboard#people'
  get '/settings', to: 'dashboard#settings', as: 'settings'
  root 'home#index'
  get 'auth/github/callback', to: 'sessions#create'
  get '/login', to: 'sessions#login'
  delete '/logout', to: 'sessions#delete'
  post 'create_task', to: 'dashboard#create_task', as: 'create_task'
  get 'data/fetch_data', to: 'data#fetch_data'

end
