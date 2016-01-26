Rails.application.routes.draw do
  root 'status#show'

  resources :packages, only: [:index]
end
