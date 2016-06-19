module BlogHelper

  def all_blog_posts
    # TODO pull these from the folder
    [
      "20160618_new_book_in_the_works",
      "20160522_ghostcrime_2ed_printed",
      "20160501_spring_cleaning",
      "20160411_christian_at_geequinox"
    ]
  end

  def sample_blog_posts
    all_blog_posts[0..3]
  end

end
