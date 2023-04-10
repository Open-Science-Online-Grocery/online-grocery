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
    collection do
      get :verify_payment
    end
    resources :conditions do
      collection do
        put :refresh_form
      end
    end
    resources :data_downloads, only: [:index, :create]
  end

  resources :conditions, only: [] do
    resource :product_download, only: [:show] do
      collection do
        get :custom_categories
        get :custom_product_prices
        get :custom_product_attribute
        get :suggestions
        get :sorting
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

  resources :config_files, only: [:show]
  
  resources :paypal, defaults: { format: :json }

  resources :pages, only: [] do
    collection do
      get :getting_started
      get :tutorials
    end
  end

  get '/store/thank-you', to: 'stores#thank_you'

  root 'pages#getting_started'
end
