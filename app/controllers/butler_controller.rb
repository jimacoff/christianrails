class ButlerController < ApplicationController

  include ButlerHelper

  layout "butler"

  before_action :set_entities
  before_action :get_all_blog_posts

  skip_before_action :verify_is_admin

  def index
    get_sample_posts
  end

  def archives
  end

  def show_post
    post_name = butler_params[:post]
    if !lookup_context.find_all("/butler/blog/posts/_blog_#{ post_name }").any?
      redirect_to page_not_found_path and return
    end
    titles = @blog_posts.collect{ |x| x[:title] }
    @post = @blog_posts[ titles.index( post_name ) ]

    render 'butler/blog/show_post'
  end

  def category
    @category = butler_params[:name]
    @category_posts = []
    @blog_posts.each do |post|
      @category_posts << post if post[:category] == @category
    end

    render 'butler/blog/category'
  end

  def tag
    @tag = butler_params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'butler/blog/tag'
  end

  private

  def butler_params
    params.permit(:post, :name)
  end

  def get_sample_posts
    @sample_posts = sample_butler_posts
  end

  def get_all_blog_posts
    @blog_posts = all_butler_posts
  end

  def set_entities
    @entities = butler_entities
  end

end
