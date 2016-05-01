module ApplicationHelper

  def verify_is_admin
    current_user.nil? ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
  end

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

  def title_of(post_name)
    post_name[9..-1].gsub('_',' ').titleize
  end

end
