class Woods::PaintballsController < ApplicationController
  layout "binarywoods"

  # TODO if ever non-admin-facing, verify user can do such a thing

  def upsert
    begin
      @paintball = Woods::Paintball.where(node_id: woods_paintball_params[:node_id]).first
      @paintball.update(woods_paintball_params)
    rescue
      @paintball = Woods::Paintball.new(woods_paintball_params)
    end

    respond_to do |format|
      if @paintball.save
        tree_index = Woods::Node.find(@paintball.node_id).tree_index
        json_paintball = @paintball.as_json
        json_paintball[:tree_index] = tree_index
        format.json { render json: json_paintball, status: :ok }
      else
        format.json { render json: @paintball.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def woods_paintball_params
      params.require(:woods_paintball).permit(:palette_id, :enabled, :node_id)
    end
end
