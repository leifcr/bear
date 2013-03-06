Bear::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:index, :create, :destroy]

  resources :projects do
    member { 
      get "build"
      get "remove"
      get "arrange"
      get "feed", :format => "atom"
      get "duplicate"
      get "assignments"
      put "assignments"
    }
    match "/hooks/:name/configure", :to => "hooks#configure", :as => "config_hook"
  end

  resources :builds, :except => [:edit, :update, :create]
  match '/builds/output/:id/*path', :to => "builds#output"
  match '/builds/output/:id', :to => "builds#output"
  match '/builds/log/:id/*path', :to => "builds#log"
  match '/builds/log/:id', :to => "builds#log"

  resources :step_lists
  resources :shared_variables

  match "/hooks/build/:hook_name",        :to => "hooks#autobuild",   :via => :post
  match "/hooks/build/github/:secure",    :to => "hooks#github",      :via => :post
  match "/hooks/build/bitbucket/:secure", :to => "hooks#bitbucket",   :via => :post
  root :to => "projects#index"
end
