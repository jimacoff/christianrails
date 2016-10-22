class Woods::PossibleitemsController < Woods::WoodsController

  # TODO if ever non-admin-facing, verify user can do such a thing

  def upsert
    begin
      @possibleitem = Woods::Possibleitem.where(node_id: woods_possibleitem_params[:node_id]).first
      @possibleitem.update(woods_possibleitem_params)
    rescue
      @possibleitem = Woods::Possibleitem.new(woods_possibleitem_params)
    end

    respond_to do |format|
      if @possibleitem.save
        tree_index = Woods::Node.find(@possibleitem.node_id).tree_index
        json_possible = @possibleitem.as_json
        json_possible[:tree_index] = tree_index
        format.json { render json: json_possible, status: :ok }
      else
        format.json { render json: @possibleitem.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def woods_possibleitem_params
      params.require(:woods_possibleitem).permit(:itemset_id, :enabled, :node_id, :perpetual)
    end
end
