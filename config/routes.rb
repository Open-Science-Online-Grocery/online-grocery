Rails.application.routes.draw do
  devise_for :users

  resources :experiments do
    member do
      get :download_data
    end

    resources :conditions
  end

  root 'experiments#index'
end
