Rails.application.routes.draw do
  resources :zones, only: [:new, :index, :create, :show] do
    resources :records, only: [:index, :create, :new, :show]
  end
  root 'zones#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
