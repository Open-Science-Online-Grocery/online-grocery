Rails.application.routes.draw do
  devise_for :users

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

  root 'experiments#index'
end
