class GoController < ApplicationController

  layout "go"

  skip_before_action :verify_is_admin, only: [:index]

  ## PUBLIC

  def index
  end

end
