class Woods::StoriesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_story, only: [:show, :edit, :update, :destroy, :play, :move_to]
  before_action :verify_is_published
  before_action :verify_is_admin

  def index
    @stories = Woods::Story.all
  end

  def play
    begin
      @storytree = Woods::Storytree.find(@story.entry_tree)
    rescue
      raise "Invalid entry tree?!?"
    end

    @node = @storytree.get_first_node
    @node = @node.add_accoutrements_and_make_json!
  end

  # JSON endpoint
  def move_to
    begin
      @node = Woods::Node.find( params[:target_node] )
      # TODO check if node in published story


      # TODO track lefts and rights


      # update user scorecard & footprints
      @storytree = Woods::Storytree.find( @node['storytree_id'] )
      @scorecard = Woods::Scorecard.includes(:footprints).where(player_id: current_player.id, story_id: @story.id)

      if @scorecard.size == 0
        @scorecard = Woods::Scorecard.create!(player_id: current_player.id, story_id: @story.id)
      else
        @scorecard = @scorecard.first
      end

      @footprint = @scorecard.footprints.where(storytree_id: @storytree.id)
      unless @footprint.size > 0
        @footprint = Woods::Footprint.create!(scorecard_id: @scorecard.id, storytree_id: @storytree.id)
        @footprint.construct_for_tree!
      else
        @footprint = @footprint.first
      end

      # any finds?
      if @node.possibleitem && @node.possibleitem.enabled && @footprint.item_at_index?(nodehash['tree_index'])
        items_player_has = current_player.finds.collect(&:item_id)
        itemset_found = Woods::Itemset.includes(:items).find( @node.possibleitem.itemset_id )
        found = itemset_found.calculate_item_found(items_player_has)
        Woods::Find.create( player_id: current_player.id, item_id: found.id, story_id: @story.id )
        nodehash.merge!( { item_found: { name: found.name, value: found.value, legend: found.legend, image: found.image } } )
      end

      @node = @node.add_accoutrements_and_make_json!(current_player.id, @footprint, items_player_has)

      @footprint.step!( @node['tree_index'] )

    rescue => e
      Rails.logger.warn("Something's wrong: " + e.to_s)
    end

    respond_to do |format|
      if @node
        format.json { render json: @node, status: :ok }
      else
        # TODO better error here
        format.json { render json: @node, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def new
    @story = Woods::Story.new
  end

  def edit
  end

  def create
    @story = Woods::Story.new(woods_story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story }
      else
        format.html { render action: 'new' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @story.update(woods_story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to woods_stories_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_story
      @story = Woods::Story.find(params[:id])
    end

    def woods_story_params
      params[:woods_story]
    end
end
