Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get 'welcome/index'

  resources :schedules

  resources :events

  root 'welcome#index'
end
