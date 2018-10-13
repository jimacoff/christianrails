class Woods::TreelinksController < Woods::WoodsController

  ## ADMIN ONLY
  # if ever non-admin-facing, verify user can do such a thing

  def upsert
    begin
      @treelink = Woods::Treelink.where(node_id: woods_treelink_params[:node_id]).first
      @treelink.update(woods_treelink_params)
    rescue
      @treelink = Woods::Treelink.new(woods_treelink_params)
    end

    respond_to do |format|
      if @treelink.save
        tree_index = Woods::Node.find(@treelink.node_id).tree_index
        json_treelink = @treelink.as_json
        json_treelink[:tree_index] = tree_index
        format.json { render json: json_treelink, status: :ok }
      else
        format.json { render json: @treelink.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def woods_treelink_params
      params.require(:woods_treelink).permit(:linked_tree_id, :enabled, :node_id)
    end

end
