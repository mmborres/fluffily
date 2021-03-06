Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'pages#home'
  resources :users, :only => [:new, :create, :index, :edit, :update]
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
  get '/woofs/:id/changepref' => 'woofs#changepref'
  patch '/woofs/:id/updatepref' => 'woofs#updatepref'

  get '/woofupdates/woofupdate' => 'woofupdates#woofupdate'
  get '/woofupdates/:id/woof/:woofid' => 'woofupdates#woof'
  get '/woofupdates/withdraw/:woofid' => 'woofupdates#withdraw'

  get '/woofupdates/:id/edit/:woofid' => 'woofupdates#edit'
  get '/woofupdates/:id/update/:woofid' => 'woofupdates#update'
  get '/woofupdates/cancel/:woofid' => 'woofupdates#cancel'
  get '/woofupdates/confirm/:woofid' => 'woofupdates#confirm'
  get '/woofupdates/:id/setupwoofup/:woofid' => 'woofupdates#setupwoofup'

  get '/breedappts/options' => 'breedappts#breedappt'
  get '/breedappts/:id/breedappt/:woofid' => 'breedappts#breedappt'
  get '/breedappts/:id/setupbreedappt/:woofid' => 'breedappts#setupbreedappt'
  get '/breedappts/reminder' => 'breedappts#reminder'
  get '/breedappts/:id/edit/:woofid' => 'breedappts#edit'
  get '/breedappts/:id/update/:woofid' => 'breedappts#update'
  get '/breedappts/cancel/:woofid' => 'breedappts#cancel'
  get '/breedappts/confirm/:woofid' => 'breedappts#confirm'

  get '/dogwalkdates/options' => 'dogwalkdates#dogwalkdate'
  get '/dogwalkdates/dogwalkdate' => 'dogwalkdates#dogwalkdate'
  get '/dogwalkdates/:id/dogwalkdate/:woofid' => 'dogwalkdates#dogwalkdate'
  get '/dogwalkdates/:id/setupdogwalkdate/:woofid' => 'dogwalkdates#setupdogwalkdate'
  get '/dogwalkdates/reminder' => 'dogwalkdates#reminder'
  get '/dogwalkdates/:id/edit/:woofid' => 'dogwalkdates#edit'
  get '/dogwalkdates/:id/update/:woofid' => 'dogwalkdates#update'
  get '/dogwalkdates/cancel/:woofid' => 'dogwalkdates#cancel'
  get '/dogwalkdates/confirm/:woofid' => 'dogwalkdates#confirm'

  get '/dogwalkdates/optionsdwonly' => 'dogwalkdates#dogwalkdate'

  get '/messages/:woofid/:id/message' => 'messages#woofmessage'
  get '/messages/message' => 'messages#woofmessage'
  get '/messages/woofmessagesend' => 'messages#woofmessagesend'
  post '/messages/woofmessagesend' => 'messages#woofmessagesend'

  get '/dogwalkdates/:woofid/:id/breakup' => 'dogwalkdates#breakup'
  get '/dogwalkdates/:woofid/breakup/confirm' => 'dogwalkdates#breakupconfirm'

end
