Rails.application.routes.draw do
  devise_for :users
  
  root to: "home#index"

  resources :dashboard do
  end

end
