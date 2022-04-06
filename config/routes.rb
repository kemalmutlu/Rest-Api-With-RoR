Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  resources :articles, only: [:index, :show]
end
