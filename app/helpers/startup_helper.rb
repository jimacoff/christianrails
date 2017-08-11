module StartupHelper

  def all_badstartup_posts
    # Add new posts at the top.
    [
      {
        slug:  "20170811_let_me_tell_you_about_my_business",
        title: "Let me tell you about my business",
        desc:  "I'll flip you an elevator pitch.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"]
      }
    ]
  end

  def sample_badstartup_posts
    all_badstartup_posts[0..0]
  end

end
