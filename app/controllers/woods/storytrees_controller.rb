class Woods::StorytreesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_storytree, only: [:show, :edit, :update, :destroy]

  # GET /woods/storytrees
  # GET /woods/storytrees.json
  def index
    @storytrees = Woods::Storytree.all
  end

  # GET /woods/storytrees/1
  # GET /woods/storytrees/1.json
  def show
  end

  # GET /woods/storytrees/new
  def new
    @storytree = Woods::Storytree.new
  end

  # GET /woods/storytrees/1/edit
  def edit
  end

  # POST /woods/storytrees
  # POST /woods/storytrees.json
  def create
    @storytree = Woods::Storytree.new(woods_storytree_params)

    respond_to do |format|
      if @storytree.save
        format.html { redirect_to @storytree, notice: 'Storytree was successfully created.' }
        format.json { render action: 'show', status: :created, location: @storytree }
      else
        format.html { render action: 'new' }
        format.json { render json: @storytree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/storytrees/1
  # PATCH/PUT /woods/storytrees/1.json
  def update
    respond_to do |format|
      if @storytree.update(woods_storytree_params)
        format.html { redirect_to @storytree, notice: 'Storytree was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @storytree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/storytrees/1
  # DELETE /woods/storytrees/1.json
  def destroy
    @storytree.destroy
    respond_to do |format|
      format.html { redirect_to woods_storytrees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_storytree
      @storytree = Woods::Storytree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_storytree_params
      params[:woods_storytree]
    end
end
