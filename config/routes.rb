Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'sessions' }

  resources :users, except: :index
  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
