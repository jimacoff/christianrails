class WatchPropertiesController < ApplicationController

  before_action :set_watch_property, only: [:edit, :update, :destroy]

  skip_before_action :verify_is_admin,           only: [:check_properties]
  skip_before_action :verify_authenticity_token, only: [:check_properties]

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

  def check_properties
    WatchProperty.all.each do |watch_property|
      response = HTTParty.get( watch_property.url )

      if response.body.include?( watch_property.expected_response ) && response.code == 200
        Rails.logger.info("Property check succeeded for #{ watch_property.name }!")
      else
        AdminMailer.watch_property_alert( watch_property ).deliver_now
      end
    end

    respond_to do |format|
      format.json { head :no_content }
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
