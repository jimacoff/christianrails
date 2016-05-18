class ::ButlerController < ApplicationController

  layout "butler"

  before_action :set_entities

  def index
  end

  def show_post
    @post_name = params[:post]
    if !lookup_context.find_all("/butler/posts/_blog_#{ @post_name }").any?
      redirect_to page_not_found_path
    end
  end

private

  def set_entities
    @entities = [
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
        description: "21 dark comics",
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
        description: "Official novel",
        icon: "gray-icon.png",
        code: "gray",
        theme: "blackink",
        iconH: "200",
        iconW: "130"
      },
      {
        productName: "Snapback",
        description: "Novella series",
        icon: "snapback-icon.jpg",
        code: "snapback",
        theme: "classic",
        iconH: "150",
        iconW: "225"
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
