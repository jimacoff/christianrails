class Woods::BoxesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_box, only: [:update]
  before_action :verify_is_admin

  # POST /woods/boxes
  # POST /woods/boxes.json
  def create
    @box = Woods::Box.new(woods_box_params)

    respond_to do |format|
      if @box.save
        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render action: 'show', status: :created, location: @box }
      else
        format.html { render action: 'new' }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/boxes/1
  # PATCH/PUT /woods/boxes/1.json
  def update
    respond_to do |format|
      if @box.update(woods_box_params)
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_box
      @box = Woods::Box.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_box_params
      params[:woods_box]
    end
end
