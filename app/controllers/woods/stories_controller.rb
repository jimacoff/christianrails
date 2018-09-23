class Woods::StoriesController < Woods::WoodsController

  before_action :set_woods_story, only: [:show, :play, :move_to, :manage, :export, :edit, :update, :item_tester]
  before_action :verify_is_published, except: [:index, :admin_listing, :show, :diamondfind, :thecalicobrief, :manage, :export, :create, :edit, :update, :item_tester]

  skip_before_action :verify_is_admin, only: [:index, :show, :play, :move_to, :diamondfind, :thecalicobrief]

  ## PUBLIC

  # listing of Binarywoods stories
  def index
    @stories = Woods::Story.where(published: true).order('created_at desc')
  end

  def show
    get_highscores
  end

  def diamondfind
    @story = Woods::Story.find( 1 )
    get_highscores
  end

  def thecalicobrief
    @story = Woods::Story.find( 15 )
    get_highscores
  end

  def play
    begin
      @storytree = Woods::Storytree.find( @story.entry_tree )
    rescue
      raise "Invalid entry tree?!?"
    end

    @node = @storytree.get_first_node
    @node = @node.add_accoutrements_and_make_json!

    if !current_user
      if session[:woods_player_id] && !session[:woods_player_id].blank?
        the_player = Woods::Player.find( session[:woods_player_id] )
      else
        the_player = Woods::Player.create
        session[:woods_player_id] = the_player.id
      end
    elsif current_user && !current_user.player
      the_player = Woods::Player.create(user_id: current_user.id)
      current_user.player = the_player
      current_user.save
    else
      the_player = current_user.player
    end

    @items = []
    items_player_has = Woods::Item.find( the_player.finds.where(story_id: @story.id).collect(&:item_id) )
    items_player_has.each do |i|
      @items << { name: i.name, value: i.value, legend: i.legend, image: i.image }
    end

    @story.total_plays += 1
    @story.save

    record_positive_event(Log::WOODS, "#{the_player.username} started a game of #{@story.name}")
  end

  # JSON endpoint
  def move_to
    #begin
      @node = Woods::Node.find( params[:target_node].to_i )
      @storytree = @node.storytree

      unless @scorecard = Woods::Scorecard.includes(:footprints).where(player_id: current_player.id, story_id: @story.id).take
        @scorecard = Woods::Scorecard.create!(player_id: current_player.id, story_id: @story.id)
      end

      if params[:dir] == "L"
        @scorecard.lefts += 1
        @scorecard.save
      elsif params[:dir] == "R"
        @scorecard.rights += 1
        @scorecard.save
      end

      unless @footprint = @scorecard.footprints.where(storytree_id: @storytree.id).take
        @footprint = Woods::Footprint.create!(scorecard_id: @scorecard.id, storytree_id: @storytree.id)
        @footprint.construct_for_tree!
      end

      # any finds at this location?
      if @node.possibleitem && @node.possibleitem.enabled && @footprint.item_at_index?(@node.tree_index)

        # determine what the player has currently
        item_ids_player_has = current_player.finds.where( story_id: @story.id ).collect(&:item_id)

        # get the itemset & figure out what item the player found
        itemset_found = Woods::Itemset.includes(:items).find( @node.possibleitem.itemset_id )
        item_found = itemset_found.calculate_item_found( item_ids_player_has )

        if item_found.is_a?( Woods::Item )
          Woods::Find.create( player_id: current_player.id, item_id: item_found.id, story_id: @story.id )
          record_positive_event(Log::WOODS, "Someone found #{ item_found.name } in #{ @story.name }!")
        else
          @errors = item_found.to_s
          item_found = nil
        end
      end

      @node = @node.add_accoutrements_and_make_json!( current_player.id, @footprint, item_found )

      @footprint.step!( @node['tree_index'] )

    #rescue => e
     # record_warning(Log::WOODS, e.to_s)
     # @errors = e.to_s
     # Rails.logger.warn("Something's wrong: " + @errors)
    #end

    if @errors
      render json: {errors: @errors}, status: :unprocessable_entity
    else
      render json: @node, status: :ok
    end

  end

  ## ADMIN ONLY

  def admin_listing
    @stories = Woods::Story.all
    @story = Woods::Story.new
  end

  def create
    @story = Woods::Story.new(woods_story_params)
    @story.player_id = current_player.id
    @story.published = false
    @story.total_plays = 0

    if @story.save
      @storytree = Woods::Storytree.create( name: "Intro", max_level: 1, story_id: @story.id )

      create_nodes_for_storytree( @storytree )
      @story.entry_tree = @storytree.id
      @story.save

      redirect_to woods_stories_path(@story), notice: 'Story was successfully created.'
    else
      redirect_to woods_stories_path(@story)
    end
  end

  def edit
  end

  def update
    if @story.update(woods_story_params)
      redirect_to manage_woods_story_path( @story ), notice: 'Story was successfully updated.'
    else
      redirect_to woods_story_palettes_path
    end
  end

  def manage
    @storytrees = @story.storytrees
    @lefts = @story.left_count
    @rights = @story.right_count

    @storytree = Woods::Storytree.new
  end

  def export
    @storytrees = @story.storytrees
    @nodes = []
    @storytrees.each do |storytree|
      storytree.nodes.each do |node|
        @nodes << node
      end
    end
  end

  def item_tester
    @items = @story.items
  end

  private

    def get_highscores
      @highscores = Woods::Player.where.not(user_id: nil)
                                 .collect{ |p| [p.username, p.total_score( @story.id ), p.id] }
                                 .sort{ |x,y| y[1] <=> x[1] }[0..4]
    end

    def set_woods_story
      @story = Woods::Story.find( params[:id] )
    end

    def woods_story_params
      params.require(:woods_story).permit(:store_link_text, :name, :description, :slug, :allow_remote_syncing, :published)
    end
end
