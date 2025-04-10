# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      resource :best, only: :create, module: :answers, controller: "best"
    end

    member do
      delete :delete_file
    end
  end
end
