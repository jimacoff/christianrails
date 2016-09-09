module BlogHelper

  def all_blog_posts
    # Add new posts at the top.
    [
      {
        title: "20160909_word_on_the_street",
        category: "Rare Public Appearances",
        tags: ["Word on the Street", "Halifax", "self-publishing", "Ghostcrime", "badger"]
      },
      {
        title: "20160816_tie_in_for_ghostcrime",
        category: "Software Development",
        tags: ["CRM", "Ghostcrime", "organization", "business", "books", "tie-ins"]
      },
      {
        title: "20160808_between_contracts",
        category: "Freelance Life",
        tags: ["freelance", "self-employment", "travelling", "British Columbia", "Snapback", "books"]
      },
      {
        title: "20160618_new_book_in_the_works",
        category: "Writing and Publishing",
        tags: ["Hal-Con", "Snapback", "Go", "Novella", "Illustration"]
      },
      {
        title: "20160522_ghostcrime_2ed_printed",
        category: "Writing and Publishing",
        tags: ["Ghostcrime", "Hal-Con", "Self-publishing"]
      },
      {
        title: "20160501_spring_cleaning",
        category: "Rare Public Appearances",
        tags: ["Ghostcrime", "Geequinox", "Convention"]
      },
      {
        title: "20160411_christian_at_geequinox",
        category: "Rare Public Appearances",
        tags: ["Ghostcrime", "Geequinox", "Convention"]
      }
    ]
  end

  def sample_blog_posts
    all_blog_posts[0..4]
  end

end
