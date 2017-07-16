module ComputersHelper

  def all_computers_posts
    # Add new posts at the top.
    [
      {
        slug: "20170527_git_for_authors",
        title: "Backing up your novel the right way",
        category: "Tutorials",
        tags: ["git", "version control", "raspberry pi", "backups", "ransomware"],
        desc: "What author needs version control? ALL OF THEM"
      }
    ]
  end

  def sample_computers_posts
    all_computers_posts[0..0]
  end

end
