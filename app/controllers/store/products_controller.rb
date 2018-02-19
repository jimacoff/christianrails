class Store::ProductsController < Store::StoreController

  before_action :set_product, only: [:edit, :update, :destroy]

  ## ADMIN ONLY

  def index
    @products = Store::Product.all
  end

  def new
    @product = Store::Product.new
  end

  def edit
  end

  def create
    @product = Store::Product.new(product_params)

    if @product.save
      redirect_to store_products_url, notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @product.update(product_params)
      redirect_to store_products_url, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to store_products_url
  end

  def downloads
    @products = Store::Product.all
  end

  private

    def set_product
      @product = Store::Product.find( params[:id] )
    end

    def product_params
      params.require(:store_product).permit(:title, :author, :short_desc, :long_desc, :price, :physical_price,
                                            :physical_sales, :rank, :image, :small_image, :logo_image, :coming_soon,
                                            :slug, :filename, :popularity_image, :free_on_signup, :giftpack_price,
                                            :giftpackable, :shipping_cost)
    end
end
