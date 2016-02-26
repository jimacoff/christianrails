module WoodsHelper

  def owns_story?(story)
    current_user && current_user.player && current_user.player.stories.include?(story) ? true : false
  end

  def verify_is_published
    redirect_to(root_path) unless @story && @story.published?
  end

end
