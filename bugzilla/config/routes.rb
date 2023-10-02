# frozen_string_literal: true

Rails.application.routes.draw do
  Rails.application.routes.draw do
    devise_for :users, defaults: { format: :json }, controllers: {
      registrations: 'users/registrations'
    }
  end
  resources :projects
  resources :bugs
  resources :home, only: :index

  namespace :api do
    namespace :v1 do
      resources :projects, only: :index, defaults: { format: :json }
    end
  end
  root 'projects#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
