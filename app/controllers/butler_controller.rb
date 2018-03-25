class ButlerController < ApplicationController

  include ButlerHelper

  layout "butler"

  before_action :set_entities
  before_action :get_all_blog_posts

  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    get_sample_posts
  end

  def show_post
    post_name = params[:post]
    if !lookup_context.find_all("/butler/blog/posts/_blog_#{ post_name }").any?
      redirect_to page_not_found_path and return
    end
    titles = @blog_posts.collect{ |x| x[:title] }
    @post = @blog_posts[ titles.index( post_name ) ]

    get_recommendations_for( @post )

    render 'butler/blog/show_post'
  end

  def category
    @category = params[:name]
    @category_posts = []
    @blog_posts.each do |post|
      @category_posts << post if post[:category] == @category
    end

    render 'butler/blog/category'
  end

  def tag
    @tag = params[:name]
    @tag_posts = []
    @blog_posts.each do |post|
      @tag_posts << post if post[:tags].include? @tag
    end

    render 'butler/blog/tag'
  end

  private

    # finds 3 tangentially-related posts to this one
    def get_recommendations_for( current_post )
      related_posts = []
      @recommended_posts = []

      all_butler_posts.each do |post|
        related_posts << post if posts_relate?( post, current_post ) && post[:title] != current_post[:title]
      end
      related_posts.shuffle!

      # choose 1 or 2 related posts
      if related_posts.size == 1
        @recommended_posts << related_posts[0]
      elsif related_posts.size >= 2
        @recommended_posts = related_posts[0..1]
      end

      # fill up the rest with random posts
      while @recommended_posts.size < 3
        @recommended_posts << get_random_post_excluding( @recommended_posts + [current_post] )
      end

      @recommended_posts.shuffle!
    end

    # either the same category or share tags
    def posts_relate?(post_a, post_b)
      post_a[:category] == post_b[:category] || (post_a[:tags] - post_b[:tags]).size < post_a[:tags].size
    end

    def get_random_post_excluding( posts_to_exclude )
      try_post = get_random_post
      while( ( [try_post] - posts_to_exclude ).size == 0 )
        try_post = get_random_post
      end
      try_post
    end

    def get_random_post
      all_butler_posts[ Random.rand( all_butler_posts.size ) ]
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
