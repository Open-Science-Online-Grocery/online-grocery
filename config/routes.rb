Rails.application.routes.draw do
  devise_for :users

  resources :experiments do
    member do
      get :download_data
      get :new_condition
      post :create_condition
    end
  end

  resources :conditions

  root 'experiments#index'
end
