Rails.application.routes.draw do
  resources :projects
  root to: 'pages#index'
end
