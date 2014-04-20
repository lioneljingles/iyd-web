IydWeb::Application.routes.draw do
  
  root 'root#index'
  
  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  namespace :org do
    get 'signup', to: 'organizations#new'
  end
  
end