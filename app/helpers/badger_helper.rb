module BadgerHelper

  def all_badger_posts
    # Add new posts at the top.
    [
      {
        title: "20160427_food_fight",
        category: "Living with wild animals",
        tags: ["Badger", "Budgeting", "Food", "High-end cheeses", "Worrying weight loss"]
      },
      {
        title: "20160106_counter_attacks",
        category: "Living with wild animals",
        tags: ["Badger", "Cold", "E-commerce", "Food safety"]
      },
      {
        title: "20150428_springtime",
        category: "Living with wild animals",
        tags: ["Badger", "Feelings of hope and trepidation", "Spring"]
      },
      {
        title: "20150329_badger_games",
        category: "Living with wild animals",
        tags: ["Badger", "De-humidifier", "Monetization", "Wholesaling", "Winter"]
      },
      {
        title: "20150226_leaks",
        category: "Living with wild animals",
        tags: ["Badger", "Badger-related deception", "Cold", "Halifax", "Infrastructure"]
      },
      {
        title: "20150128_snow_problem",
        category: "Living with wild animals",
        tags: ["Badger", "Bubble baths", "Halifax", "Misery", "Winter"]
      },
      {
        title: "20141222_housecoat",
        category: "Living with wild animals",
        tags: ["Badger", "Build tools", "Cold", "Housecoat", "Java", "Space heater"]
      },
      {
        title: "20141126_strategies",
        category: "Living with wild animals",
        tags: ["Badger", "Badger-related deception", "Consequences", "Go", "Yoga"]
      },
      {
        title: "20141119_another_november",
        category: "Living with wild animals",
        tags: ["Badger", "Cold", "Go", "Responsive web technologies", "Winter"]
      },
      {
        title: "20100204_blanket_statements",
        category: "Living with wild animals",
        tags: ["Badger", "Cold", "Consequences", "Database design"]
      },
      {
        title: "20091127_november",
        category: "Living with wild animals",
        tags: ["Badger", "Cold", "Self-loathing"]
      },
      {
        title: "20091123_a_knock_at_the_door",
        category: "Living with wild animals",
        tags: ["Badger", "Badger-related deception", "Consequences", "Surveillance"]
      },
      {
        title: "20091120_badger_for_business",
        category: "Living with wild animals",
        tags: ["Badger", "Business", "Client-oriented", "Coffee", "Meets deadlines"]
      },
      {
        title: "20091118_i_found_this_badger",
        category: "Living with wild animals",
        tags: ["Badger", "Pets", "Serendipity"]
      }
    ]
  end

  def sample_badger_posts
    all_badger_posts[0..3]
  end

end
