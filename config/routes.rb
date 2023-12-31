Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#dashboard'
  get '/repositories', to: 'dashboard#repositories'
  get '/people', to: 'dashboard#people'
  get '/settings', to: 'dashboard#settings', as: 'settings'
  root to: redirect('/dashboard') 
  get 'auth/github/callback', to: 'sessions#create'
  get '/login', to: 'sessions#login'
  delete '/logout', to: 'sessions#delete'
  post 'create_task', to: 'dashboard#create_task', as: 'create_task'
  get 'data/fetch_data', to: 'data#fetch_data'
  delete 'delete_task/:id', to: 'dashboard#delete_task', as: 'delete_task'
  post '/dashboard/create_note', to: 'dashboard#create_note', as: 'create_note_dashboard'
  delete '/dashboard/delete_note/:id', to: 'dashboard#delete_note', as: 'delete_note_dashboard'
end