class Store::FreeGiftsController < Store::StoreController

  ## ADMIN ONLY

  def index
    @free_gifts = Store::FreeGift.order('created_at desc')
  end

  def new
    @free_gift = Store::FreeGift.new
    @products  = Store::Product.all
    @users     = User.all
  end

  def create
    @free_gift = Store::FreeGift.new(free_gift_params)

    if @free_gift.save
      redirect_to store_free_gifts_url, notice: 'Free gift was successfully created.'
    else
      flash[:alert] = "Origin is required."
      redirect_to new_store_free_gift_path
    end
  end

  # TODO
  def give
  end

  private

    def free_gift_params
      params.require(:store_free_gift).permit(:user_id, :product_id, :origin)
    end
end
