Rails.application.routes.draw do
  root 'home#index'
  get 'auth/github/callback', to: 'sessions#create'
  get '/login', to: 'sessions#login'
  delete '/logout', to: 'sessions#delete'
end
