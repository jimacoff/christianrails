module CrmHelper

  def owns_assistant?(assistant)
    current_user && current_user.assistant && current_user.assistant == assistant
  end

  def verify_has_assistant
    redirect_to(root_path) unless current_assistant
  end

  def current_assistant
    current_user.assistant if current_user && current_user.assistant
  end

end
