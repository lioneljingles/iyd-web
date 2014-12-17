IydWeb::Application.routes.draw do
  
  root 'root#index'
  
  get 'contact', to: 'root#contact'
  post 'contact', to: 'root#sent'
  get 'about', to: 'root#about'
  
  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'  
  
  get '/org-list', to: 'organizations#list'
  
  get '/org', to: 'organizations#new'
  post '/org', to: 'organizations#create'
  get '/org/:slug', to: 'organizations#show', as: :org_slug
  put '/org/:slug', to: 'organizations#update'
  get '/org/:slug/edit', to: 'organizations#edit', as: :org_edit
  
  get '/opportunities', to: 'opportunities#show'
  get '/opp-list', to: 'opportunities#list'
  
  get '/org/:slug/opp', to: 'opportunities#new', as: :opp_new
  post '/org/:slug/opp', to: 'opportunities#create'
  get '/org/:slug/opp/:id/edit', to: 'opportunities#edit', as: :opp_edit
  put '/org/:slug/opp/:id', to: 'opportunities#update', as: :opp_update
  delete '/org/:slug/opp/:id', to: 'opportunities#destroy'
  
  get '/account/', to: 'accounts#edit'
  put '/account/', to: 'accounts#update'
  get '/account/password', to: 'accounts#edit_password'
  put '/account/password', to: 'accounts#update_password'
  get '/account/reset', to: 'accounts#send_reset'
  get '/account/reset/:token', to: 'accounts#process_reset', as: :account_reset_token
  put '/account/reset/:token', to: 'accounts#complete_reset'
  
  get '/admin', to: 'admin#index'
  get '/admin/impersonate/:id', to: 'admin#impersonate', as: :admin_impersonate
  
  match '/404', to: 'root#missing', via: :all
  match '/500', to: 'root#error', via: :all
  
end