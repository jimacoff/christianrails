module BlogHelper

  # categories
  WRITING_AND_PUBLISHING  = "Writing and Publishing"
  RARE_PUBLIC_APPEARANCES = "Rare Public Appearances"
  SOFTWARE_DEVELOPMENT    = "Software Development"
  FREELANCE_LIFE          = "Freelance Life"

  def all_blog_posts
    # Add new posts at the top.
    [
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
        tags: ["CRM", "Ghostcrime", "organization", "business", "books", "tie-ins"]
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
      }
    ]
  end

  def sample_blog_posts
    all_blog_posts[0..4]
  end

end
