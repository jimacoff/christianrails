module BlogHelper

  def all_blog_posts
    [
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
    all_blog_posts[0..3]
  end

end
