Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api, defaults: { format: :json } do
    resource :cart_settings, only: [:show]
    resource :condition, only: [:show]
    resource :equation_validation, only: [:show]
    resources :participant_actions, only: [:create]
    resources :products, only: [:index]
  end

  resources :experiments do
    resources :conditions do
      collection do
        put :refresh_form
      end
    end
    resources :data_downloads, only: [:index, :create]
  end

  resource :product_download, only: [:new, :show]

  resource :store, only: [:show] do
    collection do
      get :home
      get :product
      get :search
      get :checkout
    end
  end

  resources :tag_csv_files, only: [:show]

  get '/store/thank-you', to: 'stores#thank_you'

  root 'experiments#index'
end
