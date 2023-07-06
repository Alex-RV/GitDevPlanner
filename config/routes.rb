Rails.application.routes.draw do
  # get 'home/index'
  root 'home#index'
  get 'auth/github/callback', to: 'sessions#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
