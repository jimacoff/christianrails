class Woods::BinarywoodsController < ApplicationController
  layout "binarywoods"

  #before_action :verify_is_admin

  def index
    # main landing page
    @stories = Woods::Story.where(published: true)
  end

end
