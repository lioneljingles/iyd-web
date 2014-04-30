IydWeb::Application.routes.draw do
  
  root 'root#index'
  
  get 'contact', to: 'root#contact'
  post 'contact', to: 'root#send'
  get 'about', to: 'root#about'
  
  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/reset', to: 'sessions#reset'
  
  get '/org', to: 'organizations#new'
  post '/org', to: 'organizations#create'
  
  get '/org/:slug', to: 'organizations#show', as: :org_slug
  put '/org/:slug', to: 'organization#update'
  
  get '/account/:slug/password', to: 'organization#password'
  put '/acount/:slug/password', to: 'organization#update_password'
  get '/account/:slug/details', to: 'organization#details'
  put '/account/:slug/details', to: 'organization#update_details'
  
  get "*a", :to => 'root#missing'
  
end