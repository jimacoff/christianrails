class Woods::PossibleitemsController < Woods::WoodsController

  # ADMIN ONLY

  def upsert
    begin
      @possibleitem = Woods::Possibleitem.where(node_id: possibleitem_params[:node_id]).first
      @possibleitem.update(possibleitem_params)
    rescue
      @possibleitem = Woods::Possibleitem.new(possibleitem_params)
    end

    if @possibleitem.save
      tree_index = Woods::Node.find(@possibleitem.node_id).tree_index
      json_possible = @possibleitem.as_json
      json_possible[:tree_index] = tree_index
      render json: json_possible, status: :ok
    else
      render json: @possibleitem.errors, status: :unprocessable_entity
    end

  end

  private

    def possibleitem_params
      params.require(:woods_possibleitem).permit(:itemset_id, :enabled, :node_id, :perpetual)
    end

end
