Rails.application.routes.draw do
  resources :flights do
    collection do
      get 'search'
    end
  end

  resources :bookings
  resources :users do
    collection do
      get 'login'
    end
  end

  root 'flights#index'
end
