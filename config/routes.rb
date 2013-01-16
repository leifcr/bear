BigTuna::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:index, :create, :destroy]

  if BigTuna.read_only?

    resources :projects, :only => [:index, :show] do
      member { get "feed" }
    end
    resources :builds, :only => [:show]

  else

    resources :projects do
      member { 
        get "build"
        get "remove"
        get "arrange"
        get "feed"
        get "duplicate"
        get "assignments"
        put "assignments"
      }
      match "/hooks/:name/configure", :to => "hooks#configure", :as => "config_hook"
    end
    resources :builds
    resources :step_lists
    resources :shared_variables

  end

  match "/hooks/build/:hook_name",        :to => "hooks#autobuild",   :via => :post
  match "/hooks/build/github/:secure",    :to => "hooks#github",      :via => :post
  match "/hooks/build/bitbucket/:secure", :to => "hooks#bitbucket",   :via => :post
  root :to => "projects#index"
end
