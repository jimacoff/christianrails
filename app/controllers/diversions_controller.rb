class DiversionsController < ApplicationController

  skip_before_action :verify_is_admin, only: [:index, :rainfield, :stocks]

  ## PUBLIC

  def index
  end

  def rainfield
  end

  def stocks
  end

end
