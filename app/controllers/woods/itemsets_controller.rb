class Woods::ItemsetsController < Woods::WoodsController

  before_action :set_woods_itemset, only: [:show, :destroy]
  before_action :set_woods_story

  def index
    @itemsets = Woods::Itemset.includes(:items).where(story_id: @story.id)
  end

  def show
    @items = Woods::Item.where(itemset_id: @itemset.id)
  end

  def create
    @itemset = Woods::Itemset.new(woods_itemset_params)

    respond_to do |format|
      if @itemset.save
        format.html { redirect_to @itemset, notice: 'Itemset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @itemset }
      else
        format.html { render action: 'new' }
        format.json { render json: @itemset.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @itemset.destroy
    respond_to do |format|
      format.html { redirect_to woods_itemsets_url }
      format.json { head :no_content }
    end
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
