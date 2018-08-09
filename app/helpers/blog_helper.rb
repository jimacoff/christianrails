module BlogHelper

  # categories
  WRITING_AND_PUBLISHING  = "Writing and Publishing"
  RARE_PUBLIC_APPEARANCES = "Rare Public Appearances"
  SOFTWARE_DEVELOPMENT    = "Software Development"
  FREELANCE_LIFE          = "Freelance Life"
  JUST_BUSINESS           = "Just Business"

  def all_blog_posts
    # Add new posts at the top.
    [
      {
        title: "20180808_still_more_interactive_fiction",
        category: SOFTWARE_DEVELOPMENT,
        tags: ["The Calico Brief", "interactive fiction", "Diamond Find", "writing", "programming"]
      },
      {
        title: "20180611_advanced_melon_techniques",
        category: JUST_BUSINESS,
        tags: ["business", "melon", "marketing", "ScaleQuail", "Ghostcrime"]
      },
      {
        title: "20180224_new_stuff_in_the_works",
        category: WRITING_AND_PUBLISHING,
        tags: ["writing", "new things", "self-publishing", "Geequinox", "conventions", "wolfOS"]
      },
      {
        title: "20171211_holiday_sale",
        category: WRITING_AND_PUBLISHING,
        tags: ["deals", "Ghostcrime", "Snapback", "self-publishing"]
      },
      {
        title: "20171105_november_news",
        category: JUST_BUSINESS,
        tags: ["status update", "ScaleQuail", "Diamond Find", "business"]
      },
      {
        title: "20171006_important_quail_bulletin",
        category: JUST_BUSINESS,
        tags: ["business", "ScaleQuail"]
      },
      {
        title: "20170926_snapback_shimari_released",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "self-publishing"]
      },
      {
        title: "20170805_snapback_for_free",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "deals", "self-publishing", "diamonds", "CRM"]
      },
      {
        title: "20170729_webstore_upgrade",
        category: SOFTWARE_DEVELOPMENT,
        tags: ["programming", "self-publishing", "Snapback", "Ghostcrime"]
      },
      {
        title: "20170716_on_writing_novellas",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "novellas", "illustrations", "Hal-Con", "Ghostcrime", "self-publishing"]
      },
      {
        title: "20170402_a_dream_of_spring",
        category: RARE_PUBLIC_APPEARANCES,
        tags: ["Geequinox", "conventions", "self-publishing", "Go", "Hal-Con"]
      },
      {
        title: "20161201_a_snapback_review",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "self-publishing", "Go", "reviews", "Ghostcrime"]
      },
      {
        title: "20161113_snapback_released",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "self-publishing", "Go", "Hal-Con", "deals"]
      },
      {
        title: "20161022_snapback_to_the_printers",
        category: WRITING_AND_PUBLISHING,
        tags: ["Snapback", "Hal-Con", "self-publishing", "Go", "e-commerce"]
      },
      {
        title: "20160909_word_on_the_street",
        category: RARE_PUBLIC_APPEARANCES,
        tags: ["Word on the Street", "Halifax", "self-publishing", "Ghostcrime", "badgers"]
      },
      {
        title: "20160816_tie_in_for_ghostcrime",
        category: SOFTWARE_DEVELOPMENT,
        tags: ["CRM", "Ghostcrime", "organization", "business", "books", "tie-ins", "programming"]
      },
      {
        title: "20160808_between_contracts",
        category: FREELANCE_LIFE,
        tags: ["freelance", "self-employment", "travelling", "British Columbia", "Snapback", "books"]
      },
      {
        title: "20160618_new_book_in_the_works",
        category: WRITING_AND_PUBLISHING,
        tags: ["Hal-Con", "Snapback", "Go", "novellas", "illustrations"]
      },
      {
        title: "20160522_ghostcrime_2ed_printed",
        category: WRITING_AND_PUBLISHING,
        tags: ["Ghostcrime", "Hal-Con", "Self-publishing"]
      },
      {
        title: "20160501_spring_cleaning",
        category: RARE_PUBLIC_APPEARANCES,
        tags: ["Ghostcrime", "Geequinox", "conventions"]
      },
      {
        title: "20160411_christian_at_geequinox",
        category: RARE_PUBLIC_APPEARANCES,
        tags: ["Ghostcrime", "Geequinox", "conventions"]
      },
      ####
      {
        title: "20151126_actually_did_publish_that_book",
        category: WRITING_AND_PUBLISHING,
        tags: ["success at life", "books", "Ghostcrime", "paperback"]
      },
      ####
      {
        title: "20150822_new_book_forthcoming",
        category: WRITING_AND_PUBLISHING,
        tags: ["anticipation", "Ghostcrime"]
      },
      {
        title: "20141123_breaking_badger_news",
        category: WRITING_AND_PUBLISHING,
        tags: ["badger", "blog"]
      },
      {
        title: "20140829_fractalfic_launched",
        category: SOFTWARE_DEVELOPMENT,
        tags: ["coding", "FractalFic", "interactive fiction", "Diamond Find"]
      },
      {
        title: "20140628_press_to_impress",
        category: WRITING_AND_PUBLISHING,
        tags: ["FractalFic", "ClamBlog", "Diamond Find", "coding"]
      }
    ]
  end

  def sample_blog_posts
    all_blog_posts[0..2]
  end

end
