module ComputersHelper

  def all_computers_posts
    # Add new posts at the top.
    [
      {
        slug: "20180225_backing_up_your_novel",
        title: "Backing up your novel the right way",
        category: "Tutorials",
        tags: ["git", "version control", "raspberry pi", "backups", "ransomware"],
        desc: "Protect your novel from theft, fire and computer failure, or one of those will definitely happen."
      }
    ]
  end

  def sample_computers_posts
    all_computers_posts[0..0]
  end

end
