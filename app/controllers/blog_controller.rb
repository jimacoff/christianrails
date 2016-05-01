class BlogController < ApplicationController

  skip_before_action :verify_is_admin

  def index
  end

  def archives
  end

  def show_post
    @post_name = params[:post]
    if !lookup_context.find_all("/blog/posts/_blog_#{ @post_name }").any?
      redirect_to page_not_found_path
    end
  end

end
