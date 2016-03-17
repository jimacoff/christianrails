class Woods::StoriesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_story, only: [:show, :edit, :update, :destroy, :play, :move_to]
  before_action :verify_is_published, except: [:index]

  def index
    @stories = Woods::Story.all
  end

  def show
  end

  def play
    begin
      @storytree = Woods::Storytree.find(@story.entry_tree)
    rescue
      raise "Invalid entry tree?!?"
    end

    @node = @storytree.get_first_node
    @node = @node.add_accoutrements_and_make_json!

    @items = []
    items_player_has = Woods::Item.find( current_player.finds.collect(&:item_id) )
    items_player_has.each do |i|
      @items << { name: i.name, value: i.value, legend: i.legend, image: i.image }
    end
    @items = @items.to_json

    @story.total_plays += 1
    @story.save
  end

  # JSON endpoint
  def move_to
    #begin
      @node = Woods::Node.find( params[:target_node] )
      # TODO check if node in published story


      # update user scorecard & footprints
      @storytree = Woods::Storytree.find( @node['storytree_id'] )
      @scorecard = Woods::Scorecard.includes(:footprints).where(player_id: current_player.id, story_id: @story.id)

      if @scorecard.size == 0
        @scorecard = Woods::Scorecard.create!(player_id: current_player.id, story_id: @story.id)
      else
        @scorecard = @scorecard.first
      end

      dir = params[:dir]
      if dir == "L"
        @scorecard.lefts += 1
        @scorecard.save
      elsif dir == "R"
        @scorecard.rights += 1
        @scorecard.save
      end

      @footprint = @scorecard.footprints.where(storytree_id: @storytree.id)
      unless @footprint.size > 0
        @footprint = Woods::Footprint.create!(scorecard_id: @scorecard.id, storytree_id: @storytree.id)
        @footprint.construct_for_tree!
      else
        @footprint = @footprint.first
      end

      # any finds?
      if @node.possibleitem && @node.possibleitem.enabled && @footprint.item_at_index?(@node.tree_index)
        items_player_has = current_player.finds.collect(&:item_id)
        itemset_found = Woods::Itemset.includes(:items).find( @node.possibleitem.itemset_id )
        found = itemset_found.calculate_item_found(items_player_has)
        Woods::Find.create( player_id: current_player.id, item_id: found.id, story_id: @story.id ) if found
      end

      @node = @node.add_accoutrements_and_make_json!(current_player.id, @footprint, found)

      @footprint.step!( @node['tree_index'] )

    #rescue => e
    #  Rails.logger.warn("Something's wrong: " + e.to_s)
    #end

    respond_to do |format|
      if @node
        format.json { render json: @node, status: :ok }
      else
        # TODO better error here
        format.json { render json: @node, status: :unprocessable_entity }
      end
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
