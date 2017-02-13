class Woods::StorytreesController < Woods::WoodsController

  before_action :set_woods_storytree, only: [:show, :destroy]
  before_action :set_woods_story

  ## ADMIN ONLY

  # the story editor
  def show
    @nodes = @storytree.nodes.order('tree_index asc')

    @treelinks = {}
    @paintballs = {}
    @possibleitems = {}
    @boxes = {}
    @palettes = {}
    @storytrees = {}
    @itemsets = {}

    # accoutrements
    @nodes.each do |node|
      @treelinks[node.tree_index]  = node.treelink if node.treelink
      @paintballs[node.tree_index] = node.paintball if node.paintball
      @possibleitems[node.tree_index] = node.possibleitem if node.possibleitem
      @boxes[node.tree_index] = node.box if node.box
    end

    # resources
    Woods::Palette.all.each do |palette|
      @palettes[palette.id] = palette
    end
    @story.storytrees.each do |storytree|
      @storytrees[storytree.id] = storytree unless storytree.id == @storytree.id
    end
    @story.itemsets.each do |itemset|
      @itemsets[itemset.id] = itemset
    end

  end

  def create
    @storytree = Woods::Storytree.new(woods_storytree_params)
    @storytree.story_id = woods_storytree_params[:story_id]
    @storytree.save!
    create_nodes_for_storytree( @storytree )

    redirect_to manage_woods_story_path( @story ), notice: 'Storytree was successfully created.'
  end

  private
    def set_woods_storytree
      @storytree = Woods::Storytree.includes(nodes: [:treelink, :paintball, :possibleitem, :box]).find(params[:id])
    end

    def set_woods_story
      @story = Woods::Story.find(params[:story_id])
    end

    def woods_storytree_params
      params.require(:woods_storytree).permit(:name, :max_level, :story_id)
    end

end
