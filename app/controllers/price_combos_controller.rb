class PriceCombosController < ApplicationController
  before_action :set_price_combo, only: [:edit, :update, :destroy]

  ## ADMIN ONLY

  def index
    @price_combos = PriceCombo.all
  end

  def new
    @price_combo = PriceCombo.new
  end

  def edit
  end

  def create
    @price_combo = PriceCombo.new(price_combo_params)

    if @price_combo.save
      redirect_to price_combos_url, notice: 'Price combo was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @price_combo.update(price_combo_params)
      redirect_to price_combos_url, notice: 'Price combo was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @price_combo.destroy
    redirect_to price_combos_url
  end

  private
    def set_price_combo
      @price_combo = PriceCombo.find(params[:id])
    end

    def price_combo_params
      params.require(:price_combo).permit(:name, :discount)
    end
end
