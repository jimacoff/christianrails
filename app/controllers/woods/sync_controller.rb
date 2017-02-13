class Woods::SyncController < Woods::WoodsController

  skip_before_action :verify_is_admin, only: [:find_node_by_desc]

  # GET -- returns a node + its story & tree indexes
  #        takes: story_name, storytree_name & tree_index
  #        uses a story-specific token to authenticate.
  def find_node_by_desc
    @node = @invalid_token = nil
    token = Rails.application.config.sync_token

    if @story = Woods::Story.where( name: params[:story_name] ).first
      if @story.allow_remote_syncing
        if !token.empty? && (token == params[:sync_token])
          @storytree = Woods::Storytree.where( story_id: @story.id, name: params[:storytree_name] ).first if @story
          @node      = Woods::Node.where( storytree_id: @storytree.id, tree_index: params[:tree_index].to_i ).first if @story && @storytree
        else
          @invalid_token = true
        end
      else
        @remote_syncing_not_enabled = true
      end
    end

    respond_to do |format|
      if @node
        format.json { render json: { node: @node, story_id: @node.storytree.story.id, storytree_id: @node.storytree_id}, status: :ok }
      else
        if @invalid_token
          format.json { render json: {errors: "Invalid sync token."}, status: :forbidden }
        elsif @remote_syncing_not_enabled
          format.json { render json: {errors: "Remote syncing not enabled."}, status: :forbidden }
        else
          format.json { render json: {errors: "Node does not exist."}, status: :unprocessable_entity }
        end
      end
    end
  end

end
