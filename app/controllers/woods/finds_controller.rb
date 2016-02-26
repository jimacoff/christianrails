class Woods::FindsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_find, only: [:show, :edit, :update, :destroy]

  # GET /woods/finds
  # GET /woods/finds.json
  def index
    @woods_finds = Woods::Find.all
  end

  # GET /woods/finds/1
  # GET /woods/finds/1.json
  def show
  end

  # GET /woods/finds/new
  def new
    @woods_find = Woods::Find.new
  end

  # GET /woods/finds/1/edit
  def edit
  end

  # POST /woods/finds
  # POST /woods/finds.json
  def create
    @woods_find = Woods::Find.new(woods_find_params)

    respond_to do |format|
      if @woods_find.save
        format.html { redirect_to @woods_find, notice: 'Find was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_find }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_find.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/finds/1
  # PATCH/PUT /woods/finds/1.json
  def update
    respond_to do |format|
      if @woods_find.update(woods_find_params)
        format.html { redirect_to @woods_find, notice: 'Find was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_find.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/finds/1
  # DELETE /woods/finds/1.json
  def destroy
    @woods_find.destroy
    respond_to do |format|
      format.html { redirect_to woods_finds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_find
      @woods_find = Woods::Find.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_find_params
      params[:woods_find]
    end
end
