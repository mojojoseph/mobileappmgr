Rails.application.routes.draw do
  get "mobileapps" => "mobileappmgr/mobileapps#index", :as => :mobileappmgr
end
