class BlogController < ApplicationController

  include BlogHelper

  skip_before_action :verify_is_admin
  before_action :get_all_blog_posts

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

  private

  def get_all_blog_posts
    @blog_posts = all_blog_posts
  end

end
