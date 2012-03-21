module MobileAppMgr

  class Engine < Rails::Engine

    initialize "mobileappmgr.load_app_instance_data" do |app|
      MobileAppMgr.setup do |config|
        config.app_root = app.root
      end
    end

    initialize "mobileappmgr.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end

end
