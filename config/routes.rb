Rails.application.routes.draw do
  root 'home#index'
  # get 'auth/github/callback', to: 'sessions#create', as: :omniauth_callback
end
