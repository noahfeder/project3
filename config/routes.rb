Rails.application.routes.draw do

  resources :weathers
  root to: "users#index"
  resources :sessions, only: [:create,:destroy]
  get "/signout" => "sessions#destroy", :as => :signout
  resources :users
  resources :todos


end
