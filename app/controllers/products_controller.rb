class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]

  ## ADMIN ONLY

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_url, notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_url, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  def downloads
    @products = Product.all
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :author, :short_desc, :long_desc, :price, :physical_price, :rank, :image, :small_image, :coming_soon)
    end
end
