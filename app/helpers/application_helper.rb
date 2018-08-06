module ApplicationHelper

  # blog helpers for stats purposes
  include BadgerHelper
  include BlogHelper
  include ButlerHelper
  include ComputersHelper
  include QuailHelper

  def app_version
    yaml_file_path = "#{::Rails.root}/config/version.yml"
    parts = YAML.load(File.read(yaml_file_path)).symbolize_keys
    "#{ parts[:major] }.#{ parts[:minor] }.#{ parts[:patch] }"
  end

  def date_of(post_name)
    begin
      Date.new( post_name[0..3].to_i, post_name[4..5].to_i, post_name[6..7].to_i )
    rescue
      ""
    end
  end

  # turns a blog post slug into titleized string
  def title_of(post_name)
    post_name[9..-1].gsub('_',' ').titleize
  end

  def get_site_stats
    stats = {}
    stats['Days since blog post'] = get_days_since( date_of_last_blog_post )
    stats['Days since last sign-up'] = get_days_since( date_of_last_created( User ) )
    stats['Days since last book download'] = get_days_since( date_of_last_created( Store::Download ) )
    stats['Days since last item download'] = get_days_since( date_of_last_created( Woods::ItemDownload ) )
    stats['Days since last purchase (digital)'] = get_days_since( date_of_last_created( Store::DigitalPurchase ) )
    stats['Days since last purchase (physical)'] = get_days_since( date_of_last_created( Store::PhysicalPurchase ) )
    stats['Days since last melon click'] = get_days_since( date_of_last_created( Melon ) )
    stats
  end

  private

    def date_of_last_blog_post
      date_data = []
      date_data << all_badger_posts.collect{     |x| date_of (get_date_from( x[:slug] ) ) }
      date_data << all_blog_posts.collect{       |x| date_of (get_date_from( x[:title]) ) }
      date_data << all_butler_posts.collect{     |x| date_of (get_date_from( x[:title]) ) }
      date_data << all_computers_posts.collect{  |x| date_of (get_date_from( x[:slug] ) ) }
      date_data << all_scalequail_posts.collect{ |x| date_of (get_date_from( x[:date] ) ) }
      date_data.flatten.max.to_datetime
    end

    def get_date_from( data )
      data[0..7]
    end

    def get_days_since( date )
      date ? ((DateTime.current.to_i - date.to_i) / 86400).to_s : "n/a"
    end

    def date_of_last_created( klass )
      klass.count > 0 ? klass.order('created_at desc').take.created_at : nil
    end

end
