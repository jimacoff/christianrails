class WatchPropertiesController < ApplicationController
  before_action :set_watch_property, only: [:edit, :update, :destroy]

  def index
    @watch_properties = WatchProperty.all
  end

  def new
    @watch_property = WatchProperty.new
  end

  def edit
  end

  def create
    @watch_property = WatchProperty.new(watch_property_params)

    respond_to do |format|
      if @watch_property.save
        format.html { redirect_to watch_properties_url, notice: 'WatchProperty was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @watch_property.update(watch_property_params)
        format.html { redirect_to watch_properties_url, notice: 'WatchProperty was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @watch_property.destroy
    respond_to do |format|
      format.html { redirect_to watch_properties_url, notice: 'WatchProperty was successfully destroyed.' }
    end
  end

  private
    def set_watch_property
      @watch_property = WatchProperty.find(params[:id])
    end

    def watch_property_params
      params.require(:watch_property).permit(:name, :url, :expected_response)
    end
end
