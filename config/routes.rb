Rails.application.routes.draw do
  devise_for :users
  resources :availabilities, except: [:edit, :update]
  resources :meetings, only: [:new, :index, :create, :show]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


end
