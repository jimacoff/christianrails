class GoController < ApplicationController

  layout "go"

  skip_before_action :verify_is_admin, only: [:index]

  def index
  end

end
