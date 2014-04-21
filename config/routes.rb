IydWeb::Application.routes.draw do
  
  root 'root#index'
  
  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # get '/register', to: 'sessions#register'
  get '/reset', to: 'sessions#reset'
  
  get 'org/register', to: 'organizations#new'
  post 'org/register', to: 'organizations#create'
  
end