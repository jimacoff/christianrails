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
    @storytree.story_id = params[:story_id]
    @storytree.save!
    create_nodes_for_storytree

    respond_to do |format|
      format.html { redirect_to manage_woods_story_path( @story ), notice: 'Storytree was successfully created.' }
    end
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

    def create_nodes_for_storytree
      n_nodes = ( 2 ** @storytree.max_level ) - 1
      n_nodes.times do |i|
        the_moverule = penultimate_level?( @storytree.max_level, i + 1) ? 1 : -1
        Woods::Node.create(name: "",
                           left_text: "",
                           right_text: "",
                           node_text: "",
                           moverule_id: the_moverule,
                           tree_index: i+1,
                           storytree_id: @storytree.id )
      end
    end

    def penultimate_level?(max_level, cursor)
      top_threshold = ( 2 ** max_level ) / 2
      bottom_threshold = top_threshold / 2
      (cursor < top_threshold) && (cursor <= bottom_threshold)
    end
end
