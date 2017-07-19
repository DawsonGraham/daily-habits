Rails.application.routes.draw do
  get 'messages/reply'

  resource :messages do 
    collection do
      post 'reply'
    end
  end

  get 'users/:user_id/questions/:id', :to => 'questions#destroy'

  post '/users', :to => 'users#edit'

  resources :users, only: [:index, :new, :show, :create, :edit] do
    resources :questions, only: [:index, :show, :new, :create, :destroy, :edit] do
      resources :text_answers, only: [:show, :new, :create]
      resources :boolean_answers, only: [:show, :new, :create]
      resources :integer_answers, only: [:show, :new, :create]
    end 
  end 
  resources :sessions, only: [:new, :create, :destroy]

  get 'sessions/:id', :to => 'sessions#destroy'
  # resources :text_answers, only: [:show, :new, :create]
  # resources :boolean_answers, only: [:show, :new, :create]
  # resources :integer_answers, only: [:show, :new, :create]

  root to: 'users#index'
end
