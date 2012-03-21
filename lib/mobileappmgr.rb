require "active_support/dependencies"

module MobileAppMgr
  mattr_accessor :app_root

  def self.setup
    yield self
  end
end

require "mobileappmgr/engine"
