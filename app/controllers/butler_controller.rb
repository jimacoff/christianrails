class ButlerController < ApplicationController

  layout "butler"

  def index
  end

  def archives
  end

  def show_post
    @post_name = params[:post]
    if !lookup_context.find_all("/butler/posts/_blog_#{ @post_name }").any?
      redirect_to page_not_found_path
    end
  end

private

  def error_params
    params.permit(:butler)
  end

end
