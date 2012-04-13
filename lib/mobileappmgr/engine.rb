module Mobileappmgr

  class Engine < Rails::Engine

    initializer "mobileappmgr.load_public_styles" do |app|
      if app.config.serve_static_assets
       app.config.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
    end


    initializer "mobileappmgr.load_app_instance_data", :after => :disable_dependency_loading do |app|
      Mobileappmgr.setup do |config|
        config.app_root = app.root
      end
    end

  end

end