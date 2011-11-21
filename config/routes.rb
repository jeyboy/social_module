Social::Application.routes.draw do
  get "welcome/index"

  match '/auth/:service/callback' => 'services#create'
  match '/:service/wall' => 'services#wall', :as => :service_wall

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :services, :only => [:index, :create, :destroy]

  root :to => 'welcome#index'
end
