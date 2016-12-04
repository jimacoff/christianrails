class Woods::ItemsetsController < Woods::WoodsController

  before_action :set_woods_itemset, only: [:show, :destroy]
  before_action :set_woods_story

  ## ADMIN ONLY

  def index
    @itemsets = Woods::Itemset.includes(:items).where(story_id: @story.id)
  end

  def show
    @items = Woods::Item.where(itemset_id: @itemset.id)
  end

  def create
    @itemset = Woods::Itemset.new(woods_itemset_params)

    if @itemset.save
      redirect_to @itemset, notice: 'Itemset was successfully created.'
    else
      render action: 'new'
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
      params[:woods_itemset]
    end
end
