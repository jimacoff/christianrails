class Woods::NodesController < Woods::WoodsController

  before_action :set_woods_node,                only: [:update]
  before_action :set_woods_story_and_storytree, only: [:update]

  skip_before_action :verify_is_admin, only: [:update]

  ## PUBLIC but requires sync_token if not admin

  def update
    @error = "Not authorized."

    if current_player && current_player.owns_story?( @story )
      @error = nil
    elsif @story.sync_token && !@story.sync_token.empty? && (@story.sync_token == params[:sync_token])
      @error = nil
    end
    @error = "Story/Tree/Node do not match." unless (@storytree.story_id == @story.id) && (@node.storytree_id == @storytree.id)

    if !@error && @node.update( woods_node_params )
      render json: @node, status: :ok
    else
      render json: @error || @node.errors, status: :unprocessable_entity
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
