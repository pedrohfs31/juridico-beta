Rails.application.routes.draw do
  devise_for :users
  resources :availabilities, only: [:new, :create, :index]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


end
