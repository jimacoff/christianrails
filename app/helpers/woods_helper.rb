module WoodsHelper

  def owns_story?(story)
    current_user && current_user.player && current_user.player.stories.include?(story)
  end

  def verify_is_published
    redirect_to root_path unless @story && ( @story.published? || (current_user && current_user.admin?) )
  end

  def current_player
    if current_user && current_user.player
      current_user.player
    elsif session[:woods_player_id] && !session[:woods_player_id].blank?
      begin
        Woods::Player.find( session[:woods_player_id] )
      rescue
        nil
      end
    end
  end

  def create_nodes_for_storytree( storytree )
    n_nodes = ( 2 ** storytree.max_level ) - 1
    n_nodes.times do |i|
      the_moverule = penultimate_level?( storytree.max_level, i + 1) ? 1 : -1
      Woods::Node.create(name: "",
                         left_text: "",
                         right_text: "",
                         node_text: "",
                         moverule_id: the_moverule,
                         tree_index: i+1,
                         storytree_id: storytree.id )
    end
  end

  def penultimate_level?(max_level, cursor)
    top_threshold = ( 2 ** max_level ) / 2
    bottom_threshold = top_threshold / 2
    (cursor < top_threshold) && (cursor >= bottom_threshold)
  end

end
