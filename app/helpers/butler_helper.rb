module ButlerHelper

  def all_butler_posts
    # Add new posts at the top.
    [
      {
        title: "20171231_another_year_to_evaluate",
        full_title: "2017: Another Year to Evaluate",
        category: "Summaries of Time",
        tags: ["listicle", "year in review"],
        desc: "I'm sure I can find some highlights in this dark year."
      },
      {
        title: "20170415_unpopular_diamond_finds",
        full_title: "Unpopular Versions of Diamond Find I Have Made",
        category: "Software Development",
        tags: ["listicle", "Diamond Find", "Android", "FractalFic", "obsession", "ClamBlog"],
        desc: "Made an unpopular game. Re-wrote it. Repeat."
      },
      {
        title: "20170116_4_things_computer_world_got_right",
        full_title: "4 Things 'Computer World' by Kraftwerk Got Right About 2017",
        category: "Music & Lyrics",
        tags: ["music", "Kraftwerk", "computers", "business", "numbers", "money", "people"],
        desc: "Those guys knew a thing or two about the future."
      },
      {
        title: "20161230_obligatory_2016_listicle",
        full_title: "Obligatory 2016 Listicle",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "milk technologies", "cats"],
        desc: "In list form, 2016 didn't seem too bad."
      },
      {
        title: "20160826_did_not_get_the_social_media_job",
        full_title: "Did not get the social media job",
        category: "Freelancing Stories",
        tags: ["freelancing", "Twitter", "style", "failure", "watches"],
        desc: "Could I have transformed social media? I guess we'll never know."
      },
      {
        title: "20160212_2015_in_review",
        full_title: "Belated 2015 round-up",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "food", "music", "driving"],
        desc: "It's a listicle. Why don't you click on it you robot"
      },
      {
        title: "20151126_actually_did_publish_that_book",
        full_title: "Actually did publish that book",
        category: "Books and Publishing",
        tags: ["success at life", "books", "Ghostcrime", "paperback"],
        desc: "Sometimes, I actually do finish a project."
      },
      {
        title: "20150822_new_book_forthcoming",
        full_title: "New book forthcoming",
        category: "Books and Publishing",
        tags: ["anticipation", "Ghostcrime"],
        desc: "A new book is (was) forthcoming! (it exists now)"
      },
      {
        title: "20150515_victoria_day_hacks",
        full_title: "4 Victoria Day Hacks That Can Really Modify Your Weekend",
        category: "Life Haxx",
        tags: ["listicle", "coding", "holidays", "royalty", "queens"],
        desc: "Victoria Day hacks that can really modify your long weekend."
      },
      {
        title: "20150311_go_is_great",
        full_title: "7 reasons why Go is great (other than gameplay",
        category: "Go",
        tags: ["listicle", "Go", "board games", "House of Cards"],
        desc: "Go is obviously the best game ever, but here's why."
      },
      {
        title: "20141231_2014_in_review",
        full_title: "Year in review: 2014",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "darkness"],
        desc: "2014? A solid year. Maybe you should read this listicle."
      },
      {
        title: "20141123_breaking_badger_news",
        full_title: "Breaking badger news",
        category: "Books and Publishing",
        tags: ["badger", "blog"],
        desc: "Badger news to stop the presses."
      },
      {
        title: "20140829_fractalfic_launched",
        full_title: "FractalFic launched!",
        category: "Software Development",
        tags: ["coding", "FractalFic", "interactive fiction"],
        desc: "I launched a website!"
      },
      {
        title: "20140804_not_buying_enough",
        full_title: "You Aren't Buying Enough",
        category: "Business",
        tags: ["marketing", "business", "consumerism", "essay"],
        desc: "What do you think this is -- a game?"
      },
      {
        title: "20140628_press_to_impress",
        full_title: "Press to Impress",
        category: "Books and Publishing",
        tags: ["news", "FractalFic", "ClamBlog"],
        desc: "Nothing makes a business legit like getting some SWEET press."
      },
      {
        title: "20140429_lara_game_reviews",
        full_title: "Capsule reviews of games my friend Lara gave me",
        category: "Gaming",
        tags: ["PC games", "walking simulators", "disorienting"],
        desc: "I just played some good, good games."
      },
      {
        title: "20140208_bird_related_games",
        full_title: "Bird-related games to play on your phone this weekend",
        category: "Gaming",
        tags: ["mobile games", "birds"],
        desc: "Do you like birds AND games? These might be for you."
      },
      {
        title: "20131231_2013_in_review",
        full_title: "2013 Year In Review",
        category: "Summaries of Time",
        tags: ["listicle", "year in review", "food", "coding"],
        desc: "2013 was a while ago, but it still got its own listicle."
      },
      {
        title: "20131216_animal_go_moves",
        full_title: "Animal-Themed Moves You Can Try When Playing Go",
        category: "Go",
        tags: ["listicle", "Go", "animals", "birds", "board games"],
        desc: "Go by itself is fantastic, but the animal-related moves you can play are even more awesome."
      },
      {
        title: "20131023_deer_hunter_2014",
        full_title: "Deer Hunter 2014 is Appalling, More Than Expected",
        category: "Gaming",
        tags: ["animal killing", "guns", "not a real game"],
        desc: "God DAMN this game is terrible."
      },
      {
        title: "20130815_grocery_shopping_tips",
        full_title: "Grocery Shopping Tips",
        category: "Life Haxx",
        tags: ["listicle", "food", "shopping", "deals", "gnawing hunger"],
        desc: "Maximize your grocery experience with THESE hot tips."
      },
      {
        title: "20130725_i_hate_marketing_in_2013",
        full_title: "Marketing in 2013 and How Much I Hate It",
        category: "Business",
        tags: ["marketing", "buzzwords", "consultants", "business"],
        desc: "What is this business coming to?"
      }
    ]
  end

  def sample_butler_posts
    all_butler_posts[0..3]
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
