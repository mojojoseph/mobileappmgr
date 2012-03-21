module MobileAppMgr
  class MobileappsController < ApplicationController
    # GET /mobileapps
    # GET /mobileapps.json
    def index
      @mobileapps = Mobileapp.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @mobileapps }
      end
    end
  
    # GET /mobileapps/1
    # GET /mobileapps/1.json
    def show
      @mobileapp = Mobileapp.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @mobileapp }
      end
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
