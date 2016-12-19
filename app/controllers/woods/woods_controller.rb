class Woods::WoodsController < ApplicationController
  layout "binarywoods"

  rescue_from Exception, with: :render_error

  private

    def render_error
      render '/woods/errors/server_error', status: 500
    end
end
