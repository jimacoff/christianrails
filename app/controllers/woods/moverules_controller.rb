class Woods::MoverulesController < ApplicationController
  before_action :set_woods_moverule, only: [:show, :edit, :update, :destroy]

  # GET /woods/moverules
  # GET /woods/moverules.json
  def index
    @woods_moverules = Woods::Moverule.all
  end

  # GET /woods/moverules/1
  # GET /woods/moverules/1.json
  def show
  end

  # GET /woods/moverules/new
  def new
    @woods_moverule = Woods::Moverule.new
  end

  # GET /woods/moverules/1/edit
  def edit
  end

  # POST /woods/moverules
  # POST /woods/moverules.json
  def create
    @woods_moverule = Woods::Moverule.new(woods_moverule_params)

    respond_to do |format|
      if @woods_moverule.save
        format.html { redirect_to @woods_moverule, notice: 'Moverule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_moverule }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_moverule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/moverules/1
  # PATCH/PUT /woods/moverules/1.json
  def update
    respond_to do |format|
      if @woods_moverule.update(woods_moverule_params)
        format.html { redirect_to @woods_moverule, notice: 'Moverule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_moverule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/moverules/1
  # DELETE /woods/moverules/1.json
  def destroy
    @woods_moverule.destroy
    respond_to do |format|
      format.html { redirect_to woods_moverules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_moverule
      @woods_moverule = Woods::Moverule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_moverule_params
      params[:woods_moverule]
    end
end
