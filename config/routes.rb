Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'experiments#index'

  resources :experiments do
    member do
      get :download_data
      get :new_condition
      post :create_condition
    end
  end

  resources :conditions
end
