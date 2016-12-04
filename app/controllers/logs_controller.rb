class LogsController < ApplicationController

  # ADMIN ONLY

  def index
    @logs = Log.order('created_at desc')
  end

end
