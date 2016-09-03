class Woods::StorytreesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_storytree, only: [:show, :destroy]
  before_action :set_woods_story

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

    @nodes.each do |node|
      @treelinks[node.tree_index]  = node.treelink if node.treelink
      @paintballs[node.tree_index] = node.paintball if node.paintball
      @possibleitems[node.tree_index] = node.possibleitem if node.possibleitem
      @boxes[node.tree_index] = node.box if node.box
    end

    @story.palettes.each do |palette|
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

    respond_to do |format|
      if @storytree.save
        format.html { redirect_to @storytree, notice: 'Storytree was successfully created.' }
        format.json { render action: 'show', status: :created, location: @storytree }
      else
        format.html { render action: 'new' }
        format.json { render json: @storytree.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @storytree.destroy
    respond_to do |format|
      format.html { redirect_to woods_storytrees_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_storytree
      @storytree = Woods::Storytree.find(params[:id])
    end

    def set_woods_story
      @story = Woods::Story.find(params[:story_id])
    end

    def woods_storytree_params
      params.require(:woods_storytree).permit(:name, :max_level)
    end
end
