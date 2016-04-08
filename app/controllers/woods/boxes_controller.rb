class Woods::BoxesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_box, only: [:update]

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
    def set_woods_box
      @box = Woods::Box.find(params[:id])
    end

    def woods_box_params
      params[:woods_box]
    end
end
