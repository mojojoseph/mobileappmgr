class CreateMobileAppMgrMobileapps < ActiveRecord::Migration
  def change
    create_table :mobileappmgr_mobileapps do |t|
      t.string :name
      t.string :version
      t.string :platform
      t.string :install_url
      t.string :relnotes_url

      t.timestamps
    end
  end
end
