class DownloadsController < ApplicationController

  def test
    #if @current_user
      send_file "#{Rails.root}/../../downloads/test.pdf"
    #else
    #  render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    #end
  end

  def index
    @downloads = Download.all
  end

  def create
    @download = Download.new(download_params)

    respond_to do |format|
      if @download.save
        format.html { redirect_to @download, notice: 'Download was successfully created.' }
        format.json { render action: 'show', status: :created, location: @download }
      else
        format.html { render action: 'new' }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def download_params
      params.require(:download).permit(:release_id, :user_id, :cost)
    end
end
