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

  def relative_time(datetime)
      # TODO modify to show time when flag given
    if datetime < Time.now.to_datetime  # in the past!
      return "Yesterday" if datetime.strftime("%a, %b %e") == (DateTime.now - 1.day).strftime("%a, %b %e")
      return ((DateTime.now.to_i - datetime.to_i) / 86400).to_s + " days ago"
    end
    return "Today"    if datetime.strftime("%a, %b %e") == (DateTime.now).strftime("%a, %b %e")
    return "Tomorrow" if datetime.strftime("%a, %b %e") == (DateTime.now + 1.day).strftime("%a, %b %e")
    datetime.strftime("%a, %b %e")
  end

end
