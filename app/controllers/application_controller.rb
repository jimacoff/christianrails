class ApplicationController < ActionController::Base
  
  include StoreHelper
  
  before_filter :get_products, :get_cart

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # TODO throw this in its own Controller class
  # before_action :authenticate_user!
end
