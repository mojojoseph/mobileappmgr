require 'yaml'

module Mobileappmgr
  class MobileappsController < ApplicationController
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
          mobileapp['install'] = "itms-services://?action=download-manifest&url=http://#{@sysurl}/mobileapp/#{name}_#{version}"
        else
          mobileapp['install'] = "#{name}_#{version}"
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

      apptarget = mobileapp['apptarget']
      bundleid  = mobileapp['bundleid']      
      version   = mobileapp['version']

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
    end
  
    # GET /mobileapps/new
    # GET /mobileapps/new.json
    def new
      @mobileapp = Mobileapp.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mobileapp }
      end
    end
  
    # GET /mobileapps/1/edit
    def edit
      @mobileapp = Mobileapp.find(params[:id])
    end
  
    # POST /mobileapps
    # POST /mobileapps.json
    def create
      @mobileapp = Mobileapp.new(params[:mobileapp])
  
      respond_to do |format|
        if @mobileapp.save
          format.html { redirect_to @mobileapp, notice: 'Mobileapp was successfully created.' }
          format.json { render json: @mobileapp, status: :created, location: @mobileapp }
        else
          format.html { render action: "new" }
          format.json { render json: @mobileapp.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /mobileapps/1
    # PUT /mobileapps/1.json
    def update
      @mobileapp = Mobileapp.find(params[:id])
  
      respond_to do |format|
        if @mobileapp.update_attributes(params[:mobileapp])
          format.html { redirect_to @mobileapp, notice: 'Mobileapp was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @mobileapp.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /mobileapps/1
    # DELETE /mobileapps/1.json
    def destroy
      @mobileapp = Mobileapp.find(params[:id])
      @mobileapp.destroy
  
      respond_to do |format|
        format.html { redirect_to mobileapps_url }
        format.json { head :no_content }
      end
    end
  end
end
