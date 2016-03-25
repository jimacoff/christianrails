module WoodsHelper

  def owns_story?(story)
    current_user && current_user.player && current_user.player.stories.include?(story)
  end

  def verify_is_published
    redirect_to(root_path) unless @story && @story.published?
  end

  def current_player
    current_user.player if current_user && current_user.player
  end

end
