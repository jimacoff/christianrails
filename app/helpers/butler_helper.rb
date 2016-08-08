module ButlerHelper

  def all_butler_posts
    # Add new posts at the top.
    [
      {
        title: "20160212_2015_in_review",
        category: "Summaries of Time",
        tags: ["Listicle", "Year in review", "Food", "Music", "Driving"]
      },
      {
        title: "20151126_actually_did_publish_that_book",
        category: "Books and Publishing",
        tags: ["Success at life", "Books", "Ghostcrime", "Paperback"]
      },
      {
        title: "20150822_new_book_forthcoming",
        category: "Books and Publishing",
        tags: ["Anticipation", "Ghostcrime"]
      },
      {
        title: "20150515_victoria_day_hacks",
        category: "Life Haxx",
        tags: ["Listicle", "Coding", "Holidays", "Royalty"]
      },
      {
        title: "20150311_go_is_great",
        category: "Go",
        tags: ["Listicle", "Go", "Board games", "House of Cards"]
      },
      {
        title: "20141231_2014_in_review",
        category: "Summaries of Time",
        tags: ["Listicle", "Year in review", "Darkness"]
      },
      {
        title: "20141123_breaking_badger_news",
        category: "Books and Publishing",
        tags: ["Badger", "Blog"]
      },
      {
        title: "20140829_fractalfic_launched",
        category: "Software Development",
        tags: ["Coding", "FractalFic", "Interactive fiction"]
      },
      {
        title: "20140804_not_buying_enough",
        category: "Business",
        tags: ["Marketing", "Business", "Consumerism", "Essay"]
      },
      {
        title: "20140628_press_to_impress",
        category: "Books and Publishing",
        tags: ["News", "FractalFic", "ClamBlog"]
      },
      {
        title: "20140508_unpopular_diamond_finds",
        category: "Software Development",
        tags: ["Listicle", "Diamond Find", "Android", "Vinyl", "FractalFic"]
      },
      {
        title: "20140429_lara_game_reviews",
        category: "Gaming",
        tags: ["PC games", "Walking simulators", "Disorienting"]
      },
      {
        title: "20140208_bird_related_games",
        category: "Gaming",
        tags: ["Mobile games", "Birds"]
      },
      {
        title: "20131231_2013_in_review",
        category: "Summaries of Time",
        tags: ["Listicle", "Year in review", "Food", "Coding"]
      },
      {
        title: "20131216_animal_go_moves",
        category: "Go",
        tags: ["Listicle", "Go", "Animals", "Birds", "Board games"]
      },
      {
        title: "20131023_deer_hunter_2014",
        category: "Gaming",
        tags: ["Animal killing", "Guns", "Not a real game"]
      },
      {
        title: "20130815_grocery_shopping_tips",
        category: "Life Haxx",
        tags: ["Listicle", "Food", "Shopping", "Deals", "Gnawing hunger"]
      },
      {
        title: "20130725_i_hate_marketing_in_2013",
        category: "Business",
        tags: ["Marketing", "Buzzwords", "Consultants"]
      }
    ]
  end

  def sample_butler_posts
    all_butler_posts[0..3]
  end

end
