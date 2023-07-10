Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/users/login', to: 'users#login'
  get '/users/:id/messages', to: 'users#messages'
  resources :users
  get '/*a', to: 'application#not_found'
end
