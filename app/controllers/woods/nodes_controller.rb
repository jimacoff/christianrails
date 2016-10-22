class Woods::NodesController < Woods::WoodsController

  before_action :set_woods_node,                only: [:update]
  before_action :set_woods_story_and_storytree, only: [:update]

  def update
    @error = nil

    unless current_player && current_player.owns_story?( @story ) && (@storytree.story_id == @story.id) && (@node.storytree_id == @storytree.id)
      @error = "User does not have access to story."
    end

    respond_to do |format|
      if !@error && @node.update(woods_node_params)
        format.json { render json: @node, status: :ok }
      else
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_woods_node
      @node = Woods::Node.find(params[:id])
    end

    def set_woods_story_and_storytree
      @story = Woods::Story.find( params[:story_id] )
      @storytree = Woods::Storytree.find( params[:storytree_id] )
    end

    def woods_node_params
      params.require(:woods_node).permit(:moverule_id, :name, :left_text, :right_text, :node_text)
    end
end
