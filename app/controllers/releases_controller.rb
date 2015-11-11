class ReleasesController < ApplicationController
  before_action :set_release, only: [:update, :destroy]

  # stats page for all releases
  def index
    @releases = Release.all
  end

  def create
    @release = Release.new(release_params)

    respond_to do |format|
      if @release.save
        format.html { redirect_to @release, notice: 'Release was successfully created.' }
        format.json { render action: 'show', status: :created, location: @release }
      else
        format.html { render action: 'new' }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @release.update(release_params)
        format.html { redirect_to @release, notice: 'Release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @release.destroy
    respond_to do |format|
      format.html { redirect_to releases_url }
      format.json { head :no_content }
    end
  end

  private
    def set_release
      @release = Release.find(params[:id])
    end

    def release_params
      params.require(:release).permit(:product_id, :type, :release_date, :size, :version)
    end
end
