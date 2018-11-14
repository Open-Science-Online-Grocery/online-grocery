Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    resource :condition, only: [:show]
    resource :equation_validation, only: [:show]
    resources :participant_actions, only: [:create]
    resources :products, only: [:index]
  end

  resources :experiments do
    member do
      get :download_data
    end

    resources :conditions do
      collection do
        put :refresh_form
        get :download_product_data
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
  get '/store/thank-you', to: 'stores#thank_you'

  root 'experiments#index'
end
