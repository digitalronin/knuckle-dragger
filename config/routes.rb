Rails.application.routes.draw do
  resources :repos do
    resources :assignments
  end

  namespace :github do
    get 'token/req', to: 'token#req'
    get 'token/store', to: 'token#store'
  end

  root to: 'pages#index'
end
