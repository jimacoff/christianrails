class ReleasesController < ApplicationController
  before_action :set_release, only: [:edit, :update, :destroy]
  before_action :get_product, only: [:index, :new, :create, :update, :edit]

  def index
    @releases = @product.releases
  end

  def new
    @release = Release.new
  end

  def edit
  end

  def create
    @release = Release.new(release_params)
    @release.product = @product

    respond_to do |format|
      if @release.save
        format.html { redirect_to product_releases_url, notice: 'Release was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @release.update(release_params)
        format.html { redirect_to product_releases_url, notice: 'Release was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @release.destroy
    respond_to do |format|
      format.html { redirect_to product_releases_url, notice: 'Release was successfully destroyed.' }
    end
  end

  private
    def get_product
      @product = Product.find(params[:product_id])
    end

    def set_release
      @release = Release.find(params[:id])
    end

    def release_params
      params.require(:release).permit(:product_id, :format, :release_date, :size, :version, :physical_code)
    end
end
