Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'pages#home'
  resources :users, :only => [:new, :create, :index]
  resources :dogs
  #, :only => [:new, :create, :index, :edit, :show]


  get '/login' => 'session#new'
  post '/login' => 'session#create'
  #delete '/login' => 'session#destroy'
  get '/login/signout' => 'session#destroy'

  #get '/dogs/view' => 'dogs#view'
  get '/dogs/:id/delete' => 'dogs#destroy'

  get '/woofs/:id' => 'woofs#match'
  get '/woofs/:id/status' => 'woofs#status'
  get '/woofs/:id/:id2/show' => 'woofs#show'
  get '/woofs/:id/:id2/requestpage' => 'woofs#requestpage'
  get '/woofs/:id/:id2/create' => 'woofs#create'

  

end
