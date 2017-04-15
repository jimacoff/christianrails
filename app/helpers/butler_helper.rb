module ButlerHelper

  def all_butler_posts
    # Add new posts at the top.
    [
      {
        title: "20170415_unpopular_diamond_finds",
        category: "Software Development",
        tags: ["listicle", "Diamond Find", "Android", "FractalFic", "obsession", "ClamBlog"]
      },
      {
        title: "20170116_4_things_computer_world_got_right",
        category: "Music & Lyrics",
        tags: ["music", "Kraftwerk", "computers", "business", "numbers", "money", "people"]
      },
      {
        title: "20161230_obligatory_2016_listicle",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "milk technologies", "cats"]
      },
      {
        title: "20160826_did_not_get_the_social_media_job",
        category: "Freelancing Stories",
        tags: ["freelancing", "Twitter", "style", "failure", "watches"]
      },
      {
        title: "20160212_2015_in_review",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "food", "music", "driving"]
      },
      {
        title: "20151126_actually_did_publish_that_book",
        category: "Books and Publishing",
        tags: ["success at life", "books", "Ghostcrime", "paperback"]
      },
      {
        title: "20150822_new_book_forthcoming",
        category: "Books and Publishing",
        tags: ["anticipation", "Ghostcrime"]
      },
      {
        title: "20150515_victoria_day_hacks",
        category: "Life Haxx",
        tags: ["listicle", "coding", "holidays", "royalty", "queens"]
      },
      {
        title: "20150311_go_is_great",
        category: "Go",
        tags: ["listicle", "Go", "board games", "House of Cards"]
      },
      {
        title: "20141231_2014_in_review",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "darkness"]
      },
      {
        title: "20141123_breaking_badger_news",
        category: "Books and Publishing",
        tags: ["badger", "blog"]
      },
      {
        title: "20140829_fractalfic_launched",
        category: "Software Development",
        tags: ["coding", "FractalFic", "interactive fiction"]
      },
      {
        title: "20140804_not_buying_enough",
        category: "Business",
        tags: ["marketing", "business", "consumerism", "essay"]
      },
      {
        title: "20140628_press_to_impress",
        category: "Books and Publishing",
        tags: ["news", "FractalFic", "ClamBlog"]
      },
      {
        title: "20140429_lara_game_reviews",
        category: "Gaming",
        tags: ["PC games", "walking simulators", "disorienting"]
      },
      {
        title: "20140208_bird_related_games",
        category: "Gaming",
        tags: ["mobile games", "birds"]
      },
      {
        title: "20131231_2013_in_review",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "food", "coding"]
      },
      {
        title: "20131216_animal_go_moves",
        category: "Go",
        tags: ["listicle", "Go", "animals", "birds", "board games"]
      },
      {
        title: "20131023_deer_hunter_2014",
        category: "Gaming",
        tags: ["animal killing", "guns", "not a real game"]
      },
      {
        title: "20130815_grocery_shopping_tips",
        category: "Life Haxx",
        tags: ["listicle", "food", "shopping", "deals", "gnawing hunger"]
      },
      {
        title: "20130725_i_hate_marketing_in_2013",
        category: "Business",
        tags: ["marketing", "buzzwords", "consultants"]
      }
    ]
  end

  def sample_butler_posts
    all_butler_posts[0..4]
  end

  def butler_entities
    [
      {
        productName: "Snapback",
        description: "Board game adventure",
        icon: "snapback-butler-icon.png",
        code: "snapback",
        theme: "classic",
        iconH: "200",
        iconW: "131"
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
