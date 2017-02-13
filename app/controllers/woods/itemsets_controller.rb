class Woods::ItemsetsController < Woods::WoodsController

  before_action :set_woods_itemset, only: [:show, :destroy]
  before_action :set_woods_story

  ## ADMIN ONLY

  def index
    @itemsets = Woods::Itemset.includes(:items).where(story_id: @story.id)
    @itemset = Woods::Itemset.new(story_id: @story.id)
  end

  def show
    @items = Woods::Item.where(itemset_id: @itemset.id)
    @item = Woods::Item.new(itemset_id: @itemset.id)
  end

  def create
    @itemset = Woods::Itemset.new(woods_itemset_params)
    @itemset.story_id = @story.id

    if @itemset.save
      redirect_to woods_story_itemsets_path(@story, @itemset), notice: 'Itemset was successfully created.'
    else
      redirect_to woods_story_itemsets_path(@story, @itemset)
    end
  end

  def destroy
    @itemset.destroy
    redirect_to woods_itemsets_url
  end

  private
    def set_woods_itemset
      @itemset = Woods::Itemset.find(params[:id])
    end

    def set_woods_story
      @story = Woods::Story.find(params[:story_id])
    end

    def woods_itemset_params
      params.require(:woods_itemset).permit(:name)
    end
end
