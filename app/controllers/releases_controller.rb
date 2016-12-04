class ReleasesController < ApplicationController
  before_action :set_release, only: [:edit, :update, :destroy]
  before_action :get_product, only: [:index, :new, :create, :update, :edit]

  ## ADMIN ONLY

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

    if @release.save
      redirect_to product_releases_url, notice: 'Release was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @release.update(release_params)
      redirect_to product_releases_url, notice: 'Release was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @release.destroy
    redirect_to product_releases_url, notice: 'Release was successfully destroyed.'
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
