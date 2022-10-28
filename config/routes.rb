Rails.application.routes.draw do
  resources :metrics
  resources :locations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "locations#index"

  #get '/locations/refresh/:id', to: 'locations#refresh'
  get 'locations/refresh/:id', to: 'locations#refresh', :as => :locations_refresh
  get 'locations/new', to: 'locations#create', :as => :create_location

end
