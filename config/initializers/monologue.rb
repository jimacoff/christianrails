Monologue.config do |config|
  config.site_name = "Christian DeWolf"
  config.site_subtitle = "Books + Software"
  config.site_url = "https://www.christiandewolf.com"

  config.meta_description = "This is my blog about..."
  config.meta_keyword = "music, fun"

  config.admin_force_ssl = false
  config.posts_per_page = 10
  # config.preview_size = 1000

  config.disqus_shortname = "my_disqus_shortname"

  # LOCALE
  config.twitter_locale = "en" # "fr"
  config.facebook_like_locale = "en_US" # "fr_CA"
  config.google_plusone_locale = "en"

  config.layout = "layouts/application"

  # ANALYTICS
  # config.gauge_analytics_site_id = "YOUR COGE FROM GAUG.ES"
  # config.google_analytics_id = "YOUR GA CODE"

  config.sidebar = ["latest_posts", "latest_tweets", "categories", "tag_cloud"]

  #SOCIAL
  config.twitter_username = "dewolfchristian"
  config.facebook_url = "https://www.facebook.com/myhandle"
  config.facebook_logo = 'logo.png'
  config.github_username = "christiancodes"
  config.show_rss_icon = true
end
