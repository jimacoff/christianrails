class GraveyardController < ApplicationController

  skip_before_action :verify_is_admin, only: [:fractalfic]

  ## PUBLIC

  def fractalfic
  end

end
