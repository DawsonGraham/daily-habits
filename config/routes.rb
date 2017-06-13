Rails.application.routes.draw do
  get 'messages/reply'

  resource :messages do 
    collection do
      post 'reply'
    end
  end

  resources :users, only: [:index, :new, :show, :create, :edit] do
    resources :questions, only: [:show, :new, :create, :destroy] do
      resources :text_answers, only: [:show, :new, :create]
      resources :boolean_answers, only: [:show, :new, :create]
      resources :integer_answers, only: [:show, :new, :create]
    end 
  end 
  resources :sessions, only: [:new, :create, :destroy]
  # resources :text_answers, only: [:show, :new, :create]
  # resources :boolean_answers, only: [:show, :new, :create]
  # resources :integer_answers, only: [:show, :new, :create]

  root to: 'users#index'
end
