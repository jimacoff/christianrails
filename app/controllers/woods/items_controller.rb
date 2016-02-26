class Woods::ItemsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_item, only: [:show, :edit, :update, :destroy]

  # GET /woods/items
  # GET /woods/items.json
  def index
    @woods_items = Woods::Item.all
  end

  # GET /woods/items/1
  # GET /woods/items/1.json
  def show
  end

  # GET /woods/items/new
  def new
    @woods_item = Woods::Item.new
  end

  # GET /woods/items/1/edit
  def edit
  end

  # POST /woods/items
  # POST /woods/items.json
  def create
    @woods_item = Woods::Item.new(woods_item_params)

    respond_to do |format|
      if @woods_item.save
        format.html { redirect_to @woods_item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/items/1
  # PATCH/PUT /woods/items/1.json
  def update
    respond_to do |format|
      if @woods_item.update(woods_item_params)
        format.html { redirect_to @woods_item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/items/1
  # DELETE /woods/items/1.json
  def destroy
    @woods_item.destroy
    respond_to do |format|
      format.html { redirect_to woods_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_item
      @woods_item = Woods::Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_item_params
      params[:woods_item]
    end
end
