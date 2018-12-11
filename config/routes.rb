Rails.application.routes.draw do
  resources :projects

  namespace :github do
    get 'token/req', to: 'token#req'
    get 'token/store', to: 'token#store'
    post 'token/store', to: 'token#store'
  end

  root to: 'pages#index'
end
