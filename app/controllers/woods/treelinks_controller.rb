class Woods::TreelinksController < ApplicationController
  before_action :set_woods_treelink, only: [:show, :edit, :update, :destroy]

  # GET /woods/treelinks
  # GET /woods/treelinks.json
  def index
    @woods_treelinks = Woods::Treelink.all
  end

  # GET /woods/treelinks/1
  # GET /woods/treelinks/1.json
  def show
  end

  # GET /woods/treelinks/new
  def new
    @woods_treelink = Woods::Treelink.new
  end

  # GET /woods/treelinks/1/edit
  def edit
  end

  # POST /woods/treelinks
  # POST /woods/treelinks.json
  def create
    @woods_treelink = Woods::Treelink.new(woods_treelink_params)

    respond_to do |format|
      if @woods_treelink.save
        format.html { redirect_to @woods_treelink, notice: 'Treelink was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_treelink }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_treelink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/treelinks/1
  # PATCH/PUT /woods/treelinks/1.json
  def update
    respond_to do |format|
      if @woods_treelink.update(woods_treelink_params)
        format.html { redirect_to @woods_treelink, notice: 'Treelink was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_treelink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/treelinks/1
  # DELETE /woods/treelinks/1.json
  def destroy
    @woods_treelink.destroy
    respond_to do |format|
      format.html { redirect_to woods_treelinks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_treelink
      @woods_treelink = Woods::Treelink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_treelink_params
      params[:woods_treelink]
    end
end
