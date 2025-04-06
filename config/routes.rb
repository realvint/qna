Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      post :set_best, on: :member
    end
  end
end
