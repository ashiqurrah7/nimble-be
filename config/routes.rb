Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      resources :users, only: [:create]
      resources :keywords, only: [:index, :show, :create]
    end
  end
end
