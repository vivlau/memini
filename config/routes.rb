Rails.application.routes.draw do
  get 'welcome/index'

  resources :schedules

  root 'welcome#index'
end
