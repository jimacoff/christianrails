class Woods::ItemsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_item, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin, except: [:download]

  def download
    item_id = woods_item_params[:item_id]
    if current_user
      begin
        item = Woods::Item.find(item_id)
      rescue
        @error = "Download attempted on invalid item id: #{item_id} by user id: #{current_user.id}."
      end

      if !@error
        if current_user.player.has_item?(item.id)
          if current_player.item_downloads.where(item_id: item.id).size >= Woods::ItemDownload::LIMIT
            @error = "Download limit of #{Woods::ItemDownload::LIMIT} reached on item id: #{item_id} by user id: #{current_user.id}."
          else
            file_name = "#{item.value} - #{item.name}.jpg"
            send_file "#{Rails.root}/../../downloads/#{file_name}"
            Woods::ItemDownload.create(player: current_player, item: item)
            return
          end
        else
          @error = "Download attempted on unauthorized item id: #{item.id} by user id: #{current_user.id}."
        end
      end

    else
      @error = "Unauthorized download attempted on item: #{item_id} by a guest user."
    end

    Rails.logger.warn(@error)

    respond_to do |format|
      flash[:alert] = @error
      format.html { redirect_to root_path }
    end

  end

  def create
    @item = Woods::Item.new(woods_item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(woods_item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to woods_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_item
      @item = Woods::Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_item_params
      params.permit(:authenticity_token, :item_id)
    end
end
