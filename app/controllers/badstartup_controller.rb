class BadstartupController < ApplicationController

  include StartupHelper

  layout "badstartup"

  before_action :get_all_blog_posts
  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    get_sample_posts
  end

  def archives
  end

  def show_post
    slug = params[:post]
    if !lookup_context.find_all("/badstartup/posts/_blog_#{ slug }").any?
      redirect_to page_not_found_path and return
    end
    slugs = @blog_posts.collect{ |x| x[:slug] }
    @post = @blog_posts[ slugs.index( slug ) ]

    render 'badstartup/show_post'
  end

  def category
    @category = params[:name]
    @category_posts = []
    @blog_posts.each do |post|
      @category_posts << post if post[:category] == @category
    end

    render 'badstartup/category'
  end

  def tag
    @tag = params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'badstartup/tag'
  end

  private

    def get_sample_posts
      @sample_posts = sample_badstartup_posts
    end

    def get_all_blog_posts
      @blog_posts = all_badstartup_posts
    end

end
