Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  
  get 'welcome/index'

  resources :schedules

  root 'welcome#index'
end
