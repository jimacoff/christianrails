module BadgerHelper

  def all_badger_posts
    # Add new posts at the top.
    [
      {
        slug: "20160427_food_fight",
        full_title: "Food fight",
        tags: ["badger", "budgeting", "food", "high-end cheeses", "worrying weight loss"],
        description: "In which tensions in the kitchen escalate"
      },
      {
        slug: "20160106_counter_attacks",
        full_title: "Counter attacks",
        tags: ["badger", "cold", "e-commerce", "food safety"],
        description: "In which Jesse starts going up on the counter"
      },
      {
        slug: "20150428_springtime",
        full_title: "Springtime",
        tags: ["badger", "feelings of hope and trepidation", "spring"],
        description: "In which hopes are renewed"
      },
      {
        slug: "20150329_badger_games",
        full_title: "Badger games",
        tags: ["badger", "de-humidifier", "monetization", "wholesaling", "winter"],
        description: "In which a harmful pastime becomes painful"
      },
      {
        slug: "20150226_leaks",
        full_title: "Leaks",
        tags: ["badger", "badger-related deception", "cold", "halifax", "infrastructure"],
        description: "In which a ceiling is insufficient"
      },
      {
        slug: "20150128_snow_problem",
        full_title: "Snow problem",
        tags: ["badger", "bubble baths", "halifax", "misery", "winter"],
        description: "In which Jesse and I take a winter walk"
      },
      {
        slug: "20141222_housecoat",
        full_title: "Housecoat",
        tags: ["badger", "build tools", "cold", "housecoat", "java", "space heater"],
        description: "In which a precious item is borrowed"
      },
      {
        slug: "20141126_strategies",
        full_title: "Strategies",
        tags: ["badger", "badger-related deception", "consequences", "go", "yoga"],
        description: "In which a secret game is played"
      },
      {
        slug: "20141119_another_november",
        full_title: "Another November",
        tags: ["badger", "cold", "go", "responsive web technologies", "winter"],
        description: "In which the cycle repeats"
      },
      {
        slug: "20100204_blanket_statements",
        full_title: "Blanket statements",
        tags: ["badger", "cold", "consequences", "database design"],
        description: "In which a jealousy emerges"
      },
      {
        slug: "20091127_november",
        full_title: "November",
        tags: ["badger", "cold", "self-loathing"],
        description: "In which things cool down considerably"
      },
      {
        slug: "20091123_a_knock_at_the_door",
        full_title: "A knock at the door",
        tags: ["badger", "badger-related deception", "consequences", "surveillance"],
        description: "In which Jesse is scrutinized by an official"
      },
      {
        slug: "20091120_badger_for_business",
        full_title: "Bad(ger) for Business",
        tags: ["badger", "business", "client-oriented", "coffee", "meets deadlines"],
        description: "In which Jesse causes trouble for my finances"
      },
      {
        slug: "20091118_i_found_this_badger",
        full_title: "I found this badger",
        tags: ["badger", "pets", "serendipity"],
        description: "In which I find a badger"
      }
    ]
  end

  def sample_badger_posts
    all_badger_posts # sigh
  end

end
