class DownloadsController < ApplicationController

  def test
    #if @current_user
      send_file "#{Rails.root}/../../downloads/test.pdf"
    #else
    #  render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    #end
  end

  def ebook(product_id)
    if current_user && current_user.has_product?(product_id)
      send_file "#{Rails.root}/../../downloads/test.pdf"
    else
      Rails.logger.error("Unauthorized download attempted on: {#product_id}")
    end
  end
  
  def create
    @download = Download.new(download_params)

    respond_to do |format|
      if @download.save
        format.html { redirect_to store_path, notice: 'Download initiated.' }
        format.json { render @download, status: :created, location: @download }
      else
        format.html { redirect_to store_path, notice: 'Download not started.  Please try again.' }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def download_params
      params.require(:download).permit(:release_id, :user_id)
    end
end
