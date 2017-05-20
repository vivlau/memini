Rails.application.routes.draw do
  get 'sessions/create'

  get 'sessions/destroy'

  devise_for :users,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get 'welcome/index'

  resources :schedules do
    resources :events  
  end



  resources :yelps

  root 'welcome#index'
end
