class ButlerController < ApplicationController

  layout "butler"

  def index
  end

private

  def error_params
    params.permit(:butler)
  end

end
