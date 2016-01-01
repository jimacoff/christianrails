module ApplicationHelper

  def verify_is_admin
    current_user.nil? ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
  end

  def app_version
    yaml_file_path = "#{::Rails.root}/config/version.yml"
    parts = YAML.load(File.read(yaml_file_path)).symbolize_keys
    "#{parts[:major]}.#{parts[:minor]}.#{parts[:patch]}"
  end

end
