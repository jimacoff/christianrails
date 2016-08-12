class Crm::CrmController < ApplicationController
  layout "crm"

  skip_before_action :verify_is_admin
  before_action :verify_has_assistant
end
