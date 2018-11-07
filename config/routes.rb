Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    resource :category, only: [:show]
    resources :categories, only: [:index]
    resource :equation_validation, only: [:show]
    resources :participant_actions, only: [:create]
    resources :subcategories, only: [:index]
  end

  resources :experiments do
    member do
      get :download_data
    end

    resources :conditions do
      collection do
        put :refresh_form
      end
    end
  end

  resource :store, only: [:show] do
    collection do
      get :home
      get :product
      get :search
      get :checkout
    end
  end
  get '/store/thank-you', to: 'store#thank_you'

  root 'experiments#index'
end
