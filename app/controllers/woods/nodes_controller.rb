class Woods::NodesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_node, only: [:update]

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

  private
    def set_woods_node
      @node = Woods::Node.find(params[:id])
    end

    def woods_node_params
      params.require(:woods_node).permit(:moverule_id, :name, :left_text, :right_text, :node_text)
    end
end
