class PriceCombosController < ApplicationController
  before_action :set_price_combo, only: [:edit, :update, :destroy]

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

    respond_to do |format|
      if @price_combo.save
        format.html { redirect_to price_combos_url, notice: 'Price combo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @price_combo }
      else
        format.html { render action: 'new' }
        format.json { render json: @price_combo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @price_combo.update(price_combo_params)
        format.html { redirect_to price_combos_url, notice: 'Price combo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @price_combo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @price_combo.destroy
    respond_to do |format|
      format.html { redirect_to price_combos_url }
      format.json { head :no_content }
    end
  end

  private
    def set_price_combo
      @price_combo = PriceCombo.find(params[:id])
    end

    def price_combo_params
      params.require(:price_combo).permit(:name, :price)
    end
end
