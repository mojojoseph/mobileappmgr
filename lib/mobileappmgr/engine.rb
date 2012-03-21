module Mobileappmgr

  class Engine < Rails::Engine

    initializer "mobileappmgr.load_app_instance_data", :after => :disable_dependency_loading do |app|
      Mobileappmgr.setup do |config|
        config.app_root = app.root
      end
    end

  end

end
