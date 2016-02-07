class ErrorsController < ApplicationController

  def show
    render status_code.to_s, status: status_code
  end

protected

  def status_code
    error_params[:code] || 500
  end

private

  def error_params
    params.permit(:code)
  end

end
