Rails.application.routes.draw do
  resources :users, only: [:new, :show, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions, only: [:show, :new, :create, :destroy]
  resources :text_answers, only: [:show, :new, :create]
  resources :boolean_answers, only: [:show, :new, :create]
  resources :integer_answers, only: [:show, :new, :create]
end
