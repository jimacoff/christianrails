module WoodsHelper

  def owns_story?(story)
    current_user && current_user.player && current_user.player.stories.include?(story)
  end

  def verify_is_published
    redirect_to(root_path) unless @story && @story.published?
  end

  def current_player
    if current_user
      if current_user.player
        current_user.player
      else
        currnt_user.player = Woods::Player.create(user_id: current_user.id)
      end
    end
  end

end
