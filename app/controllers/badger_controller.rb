class BadgerController < ApplicationController

  include BadgerHelper

  layout "badger"

  before_action :get_all_blog_posts
  skip_before_action :verify_is_admin

  def index
    get_sample_posts
  end

  def archives
  end

  def show_post
    post_name = badger_params[:post]
    if !lookup_context.find_all("/badger/posts/_blog_#{ post_name }").any?
      redirect_to page_not_found_path and return
    end
    titles = @blog_posts.collect{ |x| x[:title] }
    @post = @blog_posts[ titles.index( post_name ) ]

    render 'badger/show_post'
  end

  def tag
    @tag = badger_params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'badger/tag'
  end

private

  def badger_params
    params.permit(:post, :name)
  end

  def get_sample_posts
    @sample_posts = sample_badger_posts
  end

  def get_all_blog_posts
    @blog_posts = all_badger_posts
  end

end
