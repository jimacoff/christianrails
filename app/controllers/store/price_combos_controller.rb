class Store::PriceCombosController < Store::StoreController
  before_action :set_price_combo, only: [:edit, :update, :destroy]

  ## ADMIN ONLY

  def index
    @price_combos = Store::PriceCombo.all
  end

  def new
    @price_combo = Store::PriceCombo.new
  end

  def edit
  end

  def create
    @price_combo = Store::PriceCombo.new(price_combo_params)

    if @price_combo.save
      redirect_to store_price_combos_url, notice: 'Price combo was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @price_combo.update(price_combo_params)
      redirect_to store_price_combos_url, notice: 'Price combo was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @price_combo.destroy
    redirect_to store_price_combos_url
  end

  private
    def set_price_combo
      @price_combo = Store::PriceCombo.find(params[:id])
    end

    def price_combo_params
      params.require(:store_price_combo).permit(:name, :discount_cents)
    end
end
