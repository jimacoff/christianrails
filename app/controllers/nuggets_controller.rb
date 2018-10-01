class NuggetsController < ApplicationController

  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    @nuggets = Nugget.order('serial_number asc')
  end

end
