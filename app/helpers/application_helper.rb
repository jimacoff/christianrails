module ApplicationHelper

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

end
