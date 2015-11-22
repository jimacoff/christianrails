class ReleasesController < ApplicationController
  before_action :set_release, only: [:update, :destroy]

  def create
    @release = Release.new(release_params)

    respond_to do |format|
      if @release.save
        format.html { redirect_to product_url(@release.product), notice: 'Release was successfully created.' }
        format.json { render action: 'show', status: :created, location: @release }
      else
        format.html { redirect_to product_url(@release.product) }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @release.update(release_params)
        format.html { redirect_to product_url(@release.product), notice: 'Release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'product/edit', location: @release.product }
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
      params.require(:release).permit(:product_id, :format, :release_date, :size, :version, :file_name)
    end
end
