class Woods::BoxesController < Woods::WoodsController

  ## ADMIN ONLY
  # if ever non-admin-facing, verify user can do such a thing

  def upsert
    begin
      @box = Woods::Box.where(node_id: woods_box_params[:node_id]).first
      @box.update(woods_box_params)
    rescue
      @box = Woods::Box.new(woods_box_params)
    end

    respond_to do |format|
      if @box.save
        tree_index = Woods::Node.find(@box.node_id).tree_index
        json_box = @box.as_json
        json_box[:tree_index] = tree_index
        format.json { render json: json_box, status: :ok }
      else
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def woods_box_params
      params.require(:woods_box).permit(:itemset_id, :enabled, :node_id)
    end

end
