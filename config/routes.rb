Rails.application.routes.draw do
  devise_for :users
  resources :availabilities, except: [:edit, :update]
  resources :meetings,except: [:edit, :update]
    resources :meetings,except: [:edit, :update] do
      get 'canceled', on: :collection, controller: "meetings", action: "index"
    end
  get 'canceled', to: 'pages#canceled'
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


end
