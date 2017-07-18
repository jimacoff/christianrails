class WatchPropertiesController < ApplicationController

  before_action :set_watch_property, only: [:edit, :update, :destroy]

  # ADMIN ONLY

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

    if @watch_property.save
      redirect_to watch_properties_url, notice: 'WatchProperty was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @watch_property.update(watch_property_params)
      redirect_to watch_properties_url, notice: 'WatchProperty was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @watch_property.destroy
    redirect_to watch_properties_url, notice: 'WatchProperty was successfully destroyed.'
  end

  private
    def set_watch_property
      @watch_property = WatchProperty.find(params[:id])
    end

    def watch_property_params
      params.require(:watch_property).permit(:name, :url, :expected_response)
    end
end
