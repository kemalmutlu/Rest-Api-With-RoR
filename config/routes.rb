Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  resources :articles, only: [:index, :show, :create]
end
