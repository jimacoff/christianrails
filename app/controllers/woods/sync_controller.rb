class Woods::SyncController < Woods::WoodsController

  # GET -- returns a node
  #        takes: story_name, storytree_name & tree_index
  def find_node_by_desc
    @story     = Woods::Story.where( name: params[:story_name] ).first
    @storytree = Woods::Storytree.where( story_id: @story.id, name: params[:storytree_name] ).first if @story
    @node      = Woods::Node.where( storytree_id: @storytree.id, tree_index: params[:tree_index].to_i ).first if @story && @storytree

    respond_to do |format|
      if @node
        format.json { render json: { node: @node, story_id: @node.storytree.story.id, storytree_id: @node.storytree_id}, status: :ok }
      else
        format.json { render json: {errors: "Node does not exist."}, status: :unprocessable_entity }
      end
    end
  end

end
