class Woods::ItemsController < Woods::WoodsController

  before_action :set_woods_item,   only: [:show, :edit, :update, :destroy]
  before_action :set_woods_params, only: [:show, :edit, :update, :destroy, :create]
  skip_before_action :verify_is_admin, only: [:download]

  # PUBLIC

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
            record_positive_event(Log::WOODS, "#{current_user.username} downloaded #{item.name}")
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
    flash[:alert] = @error
    redirect_to root_path
  end

  ## ADMIN ONLY

  def create
    @item = Woods::Item.new(woods_item_params)
    @item.itemset_id = @itemset.id

    if @item.save!
      redirect_to woods_story_itemset_path(@story, @itemset), notice: 'Item was successfully created.'
    else
      redirect_to woods_story_itemset_path(@story, @itemset)
    end
  end

  def update
    if @item.update(woods_item_params)
      redirect_to woods_story_itemset_path(@story, @itemset), notice: 'Item was successfully updated.'
    else
      redirect_to woods_story_itemsets_path(@story, @itemset)
    end
  end

  def destroy
    @item.destroy
    redirect_to woods_items_url
  end

  private

    def set_woods_item
      @item = Woods::Item.find(params[:id])
    end

    def set_woods_params
      @story = Woods::Story.find(params[:story_id])
      @itemset = Woods::Itemset.find(params[:itemset_id])
    end

    def woods_item_params
      params.require(:woods_item).permit(:item_id, :name, :legend, :value, :itemset_id)
    end
end
