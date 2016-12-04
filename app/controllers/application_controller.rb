class ApplicationController < ActionController::Base

  include ApplicationHelper
  include StoreHelper
  include WoodsHelper
  include CrmHelper
  include LogHelper

  before_action :verify_is_admin
  after_action :store_location
  around_action :set_time_zone, if: :current_user

  protect_from_forgery with: :exception

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  private

    def set_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block)
    end

    def verify_is_admin
      unless controller_path.start_with?('devise') || controller_path.start_with?('registrations')
        if !current_user
          redirect_to(root_path)
        else
          redirect_to(root_path) unless current_user.admin?
        end
      end
    end

end
