Rails.application.routes.draw do
  root 'home#index'
  get 'auth/github/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#delete'
end
