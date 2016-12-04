class WatchPropertiesController < ApplicationController

  before_action :set_watch_property, only: [:edit, :update, :destroy]

  skip_before_action :verify_is_admin,           only: [:check_properties]
  skip_before_action :verify_authenticity_token, only: [:check_properties]

  ## PUBLIC

  def check_properties
    WatchProperty.all.each do |watch_property|
      if !watch_property.last_checked || watch_property.last_checked + 23.hours < DateTime.now
        response = HTTParty.get( watch_property.url )
        if response.body.include?( watch_property.expected_response ) && response.code == 200
          Rails.logger.info("Property check succeeded for #{ watch_property.name }!")
          watch_property.last_checked = DateTime.now
          watch_property.save
        else
          AdminMailer.watch_property_alert( watch_property ).deliver_now
        end
      else
        ## TODO log it
      end
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

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
