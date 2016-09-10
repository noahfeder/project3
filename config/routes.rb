Rails.application.routes.draw do

  root to: "users#index"
  resources :sessions, only: [:create,:destroy]
  get "/signout" => "sessions#destroy", as: :signout
  get "/tweets" => "data#tweets", as: :tweets
  get "/articles" => "data#articles", as: :articles
  get "/weather" => "data#weather", as: :weather
  get "/sound" => "data#sound", as: :sound
  resources :users
  resources :todos, only: [:index,:create,:destroy,:update]


end
