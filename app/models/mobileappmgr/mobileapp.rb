module MobileAppMgr
  class Mobileapp < ActiveRecord::Base
      attr_accessible :name, :version, :platform, :install_url, :relnotes_url
  end
end
