class ScalequailController < ApplicationController

  include QuailHelper
  include StoreHelper

  layout "scalequail"

  before_action :get_all_blog_posts, :get_products
  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    get_sample_posts
  end

  def archives
  end

  def show_post
    req_post = params[:post]
    posts = @blog_posts.select{ |x| x[:slug] == req_post }
    @post = posts[0]

    if !@post || !lookup_context.find_all("/scalequail/posts/_blog_#{ @post[:sequence] }_#{ @post[:slug] }").any?
      redirect_to page_not_found_path and return
    end

    render 'scalequail/show_post'
  end

  def category
    @category = params[:name]
    @category_posts = []
    @blog_posts.each do |post|
      @category_posts << post if post[:category] == @category
    end

    render 'scalequail/category'
  end

  def tag
    @tag = params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'scalequail/tag'
  end

  private

    def get_sample_posts
      @sample_posts = sample_scalequail_posts
    end

    def get_all_blog_posts
      @blog_posts = all_scalequail_posts
    end

end
