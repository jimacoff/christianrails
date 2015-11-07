class DownloadsController < ApplicationController

  def test
    #if @current_user
      send_file "#{Rails.root}/downloads/test.pdf"
    #else
    #  render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    #end
  end

end
