class PoliciesController < ApplicationController

  skip_before_action :verify_is_admin

  def terms_of_use
  end

  def privacy
  end

  def customer_service
  end

  def refund
  end

end
