class PriceCombosController < ApplicationController
  before_action :set_price_combo, only: [:show, :edit, :update, :destroy]

  # GET /price_combos
  # GET /price_combos.json
  def index
    @price_combos = PriceCombo.all
  end

  # GET /price_combos/1
  # GET /price_combos/1.json
  def show
  end

  # GET /price_combos/new
  def new
    @price_combo = PriceCombo.new
  end

  # GET /price_combos/1/edit
  def edit
  end

  # POST /price_combos
  # POST /price_combos.json
  def create
    @price_combo = PriceCombo.new(price_combo_params)

    respond_to do |format|
      if @price_combo.save
        format.html { redirect_to @price_combo, notice: 'Price combo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @price_combo }
      else
        format.html { render action: 'new' }
        format.json { render json: @price_combo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /price_combos/1
  # PATCH/PUT /price_combos/1.json
  def update
    respond_to do |format|
      if @price_combo.update(price_combo_params)
        format.html { redirect_to @price_combo, notice: 'Price combo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @price_combo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_combos/1
  # DELETE /price_combos/1.json
  def destroy
    @price_combo.destroy
    respond_to do |format|
      format.html { redirect_to price_combos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_combo
      @price_combo = PriceCombo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_combo_params
      params.require(:price_combo).permit(:name, :price)
    end
end
