class GraveyardController < ApplicationController

  skip_before_action :verify_is_admin

  ## PUBLIC

  def fractalfic
  end

end
