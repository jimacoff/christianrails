class Woods::ItemsetsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_itemset, only: [:show, :edit, :update, :destroy]

  # GET /woods/itemsets
  # GET /woods/itemsets.json
  def index
    @itemsets = Woods::Itemset.all
  end

  # GET /woods/itemsets/1
  # GET /woods/itemsets/1.json
  def show
  end

  # GET /woods/itemsets/new
  def new
    @itemset = Woods::Itemset.new
  end

  # GET /woods/itemsets/1/edit
  def edit
  end

  # POST /woods/itemsets
  # POST /woods/itemsets.json
  def create
    @itemset = Woods::Itemset.new(woods_itemset_params)

    respond_to do |format|
      if @itemset.save
        format.html { redirect_to @itemset, notice: 'Itemset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @itemset }
      else
        format.html { render action: 'new' }
        format.json { render json: @itemset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/itemsets/1
  # PATCH/PUT /woods/itemsets/1.json
  def update
    respond_to do |format|
      if @itemset.update(woods_itemset_params)
        format.html { redirect_to @itemset, notice: 'Itemset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @itemset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/itemsets/1
  # DELETE /woods/itemsets/1.json
  def destroy
    @itemset.destroy
    respond_to do |format|
      format.html { redirect_to woods_itemsets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_itemset
      @itemset = Woods::Itemset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_itemset_params
      params[:woods_itemset]
    end
end
