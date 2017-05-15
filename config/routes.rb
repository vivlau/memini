Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get 'welcome/index'

  resources :schedules

  resources :events

  resources :yelps

  root 'welcome#index'
end
