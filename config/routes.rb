# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      resource :best, only: :create, module: :answers, controller: "best"
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
end
