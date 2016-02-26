class Woods::NodesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_node, only: [:show, :edit, :update, :destroy]

  # GET /woods/nodes
  # GET /woods/nodes.json
  def index
    @nodes = Woods::Node.all
  end

  # GET /woods/nodes/1
  # GET /woods/nodes/1.json
  def show
  end

  # GET /woods/nodes/new
  def new
    @node = Woods::Node.new
  end

  # GET /woods/nodes/1/edit
  def edit
  end

  # POST /woods/nodes
  # POST /woods/nodes.json
  def create
    @node = Woods::Node.new(woods_node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render action: 'show', status: :created, location: @node }
      else
        format.html { render action: 'new' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/nodes/1
  # PATCH/PUT /woods/nodes/1.json
  def update
    respond_to do |format|
      if @node.update(woods_node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/nodes/1
  # DELETE /woods/nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to woods_nodes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_node
      @node = Woods::Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_node_params
      params[:woods_node]
    end
end
