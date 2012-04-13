require 'yaml'

module Mobileappmgr
  class MobileappsController < ApplicationController
    helper :formatting
    # GET /mobileapps
    # GET /mobileapps.json
    def index

      @sysurl     = request.host_with_port

      @mobileapps = []
      
      files = Dir["public/mobileapps/*.yml"]

      files.each do |file|
        mobileapp = YAML.load_file(file)

        name      = mobileapp['name']
        version   = mobileapp['version']
        platform  = mobileapp['platform']

        if platform == "iOS" then
          mobileapp['install'] = "itms-services://?action=download-manifest&url=http://#{@sysurl}/mobileapp/#{name}_ipa_#{version}"
        else
          mobileapp['install'] = "http://#{@sysurl}/mobileapp/#{name}_apk_#{version}"
        end
        @mobileapps << mobileapp
      end

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @mobileapps }
      end
    end
  
    # GET /mobileapps/1
    # GET /mobileapps/1.json
    def show

      name = params[:id]
      yml_fname = "public/mobileapps/#{name}.yml"
      mobileapp = YAML.load_file(yml_fname)

      platform  = mobileapp['platform']
      apptarget = mobileapp['apptarget']
      version   = mobileapp['version']

      if platform == "iOS" then
        bundleid  = mobileapp['bundleid']      

        sysurl = request.host_with_port
        ipaurl = "http://#{sysurl}/mobileapps/#{apptarget}.#{version}.ipa"
        
        plist_content = <<-PLIST_DOCUMENT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/
PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>items</key>
  <array>
    <dict>
      <key>assets</key>
      <array>
        <dict>
          <key>kind</key>
          <string>software-package</string>
          <key>url</key>
          <string>#{ipaurl}</string>
        </dict>
      </array>
      <key>metadata</key>
      <dict>
        <key>bundle-identifier</key>
        <string>#{bundleid}</string>
        <key>bundle-version</key>
        <string>#{version}</string>
        <key>kind</key>
        <string>software</string>
        <key>subtitle</key>
        <string></string>
        <key>title</key>
        <string>#{name}</string>
      </dict>
    </dict>
  </array>
</dict>
</plist>
PLIST_DOCUMENT

        render :text => plist_content

      else
        redirect_to "/mobileapps/#{apptarget}.#{version}.apk"
      end
    end
  end
end
  
