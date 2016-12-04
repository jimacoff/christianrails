class BlogController < ApplicationController

  include BlogHelper

  skip_before_action :verify_is_admin
  before_action :get_all_blog_posts

  ## PUBLIC

  def index
  end

  def archives
  end

  def show_post
    post_name = blog_params[:post]
    if !lookup_context.find_all("/blog/posts/_blog_#{ post_name }").any?
      redirect_to page_not_found_path and return
    end
    titles = @blog_posts.collect{ |x| x[:title] }
    @post = @blog_posts[ titles.index( post_name ) ]
  end

  def category
    @category = blog_params[:name]
    @category_posts = []
    @blog_posts.each do |post|
      @category_posts << post if post[:category] == @category
    end
  end

  def tag
    @tag = blog_params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end
  end

  private

  def blog_params
    params.permit(:post, :name)
  end

  def get_all_blog_posts
    @blog_posts = all_blog_posts
  end

end
