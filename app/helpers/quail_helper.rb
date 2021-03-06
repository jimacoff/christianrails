module QuailHelper

  def all_scalequail_posts
    # Add new posts at the bottom.
    [
      {
        sequence: 1,
        slug:  "let_me_tell_you_about_my_business",
        title: "Let me tell you about my business",
        desc:  "I'll flip you an elevator pitch.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20170826"
      },
      {
        sequence: 2,
        slug:  "have_you_tried_not_scaling_your_business",
        title: "Have you tried NOT scaling your business?",
        desc:  "\"Scaling up\" might be a little overrated, actually, thank you",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20170827"
      },
      {
        sequence: 3,
        slug:  "the_pre_scale_checklist",
        title: "The Pre-Scale Checklist",
        desc:  "Does your startup have the raw materials to start scaling? I explain what that means in the post.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20170828"
      },
      {
        sequence: 4,
        slug:  "scaling_time_has_come",
        title: "Scaling time has come",
        desc:  "My startup is about to get growth-hacked into the profitsphere.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20170829"
      },
      {
        sequence: 5,
        slug:  "business_algorithms_for_a_successful_scale",
        title: "Business algorithms for a successful scale",
        desc:  "Codify your startup principles with these reductive rules of thumb.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20170830"
      },
      {
        sequence: 6,
        slug:  "scaling_up_digital_sales_using_peoples_existing_friendships",
        title: "Scaling up digital sales using peoples' existing friendships",
        desc:  "Make sure people are giving the gift of *you* this holiday season.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20171008"
      },
      {
        sequence: 7,
        slug:  "cracking_the_physical_distribution_problem",
        title: "Cracking the physical distribution problem",
        desc:  "Obviously we're going to use software to do this.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20180228"
      },
      {
        sequence: 8,
        slug:  "overcharging_for_loyalty",
        title: "Overcharging for loyalty: a classic scale",
        desc:  "Maybe this doesn't even work — but we're going to find out.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business"],
        date: "20180311"
      },
      {
        sequence: 9,
        slug:  "socializing_with_customers",
        title: "Socializing with customers without completely de-personalizing",
        desc:  "How to maintain an online social presence without coldly shedding your identity.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business", "Twitter", "HootSuite"],
        date: "20180519"
      },
      {
        sequence: 10,
        slug:  "monetizing_the_monolith",
        title: "Monetizing a revenue monolith with a marketing cyclone",
        desc:  "If you aren't excited by that idea, maybe you aren't capitalist enough for this line of work.",
        category: "Scaling up",
        tags:  ["scaling", "growth-hacking", "startups", "business", "cyclones", "marketing", "HootSuite"],
        date: "20180923"
      }
    ### TITLE: "max 70 characters ####################################################"
    ]
  end

  def sample_scalequail_posts
    all_scalequail_posts[1..1]
  end

  # generates dates that always feel relevant, sort of like scalequail itself
  def quail_date
    relevance_threshold = 30
    if !session[:quail_date] || session[:quail_date] < DateTime.current - relevance_threshold
      r = Random.new
      days_in_past = r.rand( relevance_threshold ) + 1
      session[:quail_date] = DateTime.current - days_in_past.days
    else
      session[:quail_date]
    end
  end

end
