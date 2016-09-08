class ::ButlerController < ApplicationController

  include ButlerHelper

  layout "butler"

  before_action :set_entities
  before_action :get_all_blog_posts

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
    @entities = [
      {
        productName: "Snapback",
        description: "Board game adventure",
        icon: "snapback-icon.jpg",
        code: "snapback",
        theme: "classic",
        iconH: "150",
        iconW: "225"
      },
      {
        productName: "Ghostcrime",
        description: "Spooky robot novel",
        icon: "ghostcrime-icon.png",
        code: "ghostcrime",
        theme: "reserve",
        iconH: "200",
        iconW: "150"
      },
      {
        productName: "Diamond Find",
        description: "Story Choice Adventure",
        icon: "diamondfind-icon.png",
        code: "diamondfind",
        theme: "classic",
        iconH: "150",
        iconW: "150"
      },
      {
        productName: "I Found This Badger",
        description: "A cautionary blog",
        icon: "thisbadger-icon.png",
        code: "thisbadger",
        theme: "blackink",
        iconH: "125",
        iconW: "125"
      },
      {
        productName: "Black Ink",
        description: "21 non-erasable comics",
        icon: "blackink-icon.jpg",
        code: "blackink",
        theme: "blackink",
        iconH: "150",
        iconW: "150",
        pages: 23,
        currentPage: 0,
        pageH: 700,
        pageW: 700,
        controlH: 50,
        controlW: 200
      },
      {
        productName: "Gray",
        description: "An official novel",
        icon: "gray-icon.png",
        code: "gray",
        theme: "blackink",
        iconH: "200",
        iconW: "130"
      },
      {
        productName: "Silver Stock",
        description: "16 shiny comics",
        icon: "silverstock-icon.jpg",
        code: "silverstock",
        theme: "reserve",
        iconH: "125",
        iconW: "200",
        pages: 21,
        currentPage: 0,
        pageH: 511,
        pageW: 715,
        controlH: 100,
        controlW: 100
      },
      {
        pageName: "Reserve",
        theme: "reserve",
        code: "reserve"
      },
      {
        pageName: "Blog",
        theme: "classic",
        code: "blog"
      },
      {
        pageName: "About",
        theme: "classic",
        code: "about"
      },
      {
        pageName: "Archives",
        theme: "classic",
        code: "archives"
      },
      {
        pageName: "Thanks for ordering!",
        theme: "reserve",
        code: "ghost-thanks"
      }
    ]
  end

end
