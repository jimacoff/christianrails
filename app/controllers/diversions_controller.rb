class DiversionsController < ApplicationController

  skip_before_action :verify_is_admin, only: [:index, :rainfield]

  ## PUBLIC

  def index
  end

  def rainfield
  end

end
