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

  # GET - HTML or JSON
  def play
    if @storytree = @story.entry_tree
      @node = @storytree.get_first_node
      @node = @node.add_accoutrements_and_make_json!

      if current_user
        if !current_user.player  # make new player for user
          the_player = Woods::Player.create(user_id: current_user.id)
          current_user.player = the_player
          current_user.save
        else  # use existing player
          the_player = current_user.player
        end
      else  # guests
        if session[:woods_player_id] && !session[:woods_player_id].blank?
          the_player = Woods::Player.find( session[:woods_player_id] )
        else
          the_player = Woods::Player.create
          session[:woods_player_id] = the_player.id
        end
      end

      @items = []
      items_player_has = Woods::Item.find( the_player.finds.where(story_id: @story.id).collect(&:item_id) )
      items_player_has.each do |i|
        @items << { name: i.name, value: i.value, legend: i.legend, image: i.image }
      end

      if @story.total_plays
        @story.total_plays += 1
      else
        @story.total_plays = 0
      end
      @story.save

      record_positive_event(Log::WOODS, "#{the_player.username} started a game of #{@story.name}")

      respond_to do |format|
        format.json { render json: {node: @node, items: @items}, status: :ok  }
        format.html { render 'play' }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'Invalid entry tree.'}, status: :unprocessable_entity  }
        format.html { redirect_to 'show' }
      end
    end
  end

  # GET - JSON
  def move_to
    begin
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

    rescue => e
      record_warning(Log::WOODS, e.to_s)
      @errors = e.to_s
    end

    if !@errors
      render json: @node, status: :ok
    else
      render json: {errors: @errors}, status: :unprocessable_entity
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
      @story.entry_tree = @storytree
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
