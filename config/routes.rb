# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[show create update destroy] do
      resource :best, only: %i[create], module: :answers, controller: "best"
    end
  end

  resources :attachments, only: %i[destroy]
  resources :rewards, only: %i[index]
  resources :votes, only: %i[create]

  mount ActionCable.server => "/cable"
end
