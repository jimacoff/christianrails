class BadgerController < ApplicationController

  include BadgerHelper

  layout "badger"

  before_action :get_all_blog_posts
  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    get_sample_posts
  end

  def archives
  end

  def show_post
    post_name = params[:post]
    if !lookup_context.find_all("/badger/posts/_blog_#{ post_name }").any?
      redirect_to page_not_found_path and return
    end
    slugs = @blog_posts.collect{ |x| x[:slug] }
    @post = @blog_posts[ slugs.index( post_name ) ]

    render 'badger/show_post'
  end

  def tag
    @tag = params[:name]

    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'badger/tag'
  end

private

  def get_sample_posts
    @sample_posts = sample_badger_posts
  end

  def get_all_blog_posts
    @blog_posts = all_badger_posts
  end

end
