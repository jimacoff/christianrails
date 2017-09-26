module QuailHelper

  def all_scalequail_posts
    # Add new posts at the top.
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
        tags:  ["scaling"],
        date: "20170826"
      },
      {
        sequence: 3,
        slug:  "the_pre_scale_checklist",
        title: "The Pre-Scale Checklist",
        desc:  "Does your startup have the raw materials to start scaling? I explain what that means in the post.",
        category: "Scaling up",
        tags:  ["scaling"],
        date: "20170826"
      },
      {
        sequence: 4,
        slug:  "scaling_time_has_come",
        title: "Scaling Time Has Come",
        desc:  "My startup is about to get growth-hacked into the profitsphere.",
        category: "Scaling up",
        tags:  ["scaling"],
        date: "20170826"
      },
      {
        sequence: 5,
        slug:  "business_algorithms_for_a_successful_scale",
        title: "Business algorithms for a successful scale",
        desc:  "Codify your startup principles with these reductive rules of thumb.",
        category: "Scaling up",
        tags:  ["scaling"],
        date: "20170826"
      },
      {
        sequence: 6,
        slug:  "scaling_up_digital_sales_using_peoples_existing_friendships",
        title: "Scaling up Digital Sales using peoples' existing friendships",
        desc:  "Make sure people are giving the gift of You this holiday season.",
        category: "Scaling up",
        tags:  ["scaling"],
        date: "20170826"
      }
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
