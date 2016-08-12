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
    if datetime.day < Time.now.day  # in the past!
      return "Yesterday" if datetime.day == Time.now.day - 1
      return (Time.now.day - datetime.day).to_s + " days ago"
    end
    return "Today"    if datetime.day == Time.now.day
    return "Tomorrow" if datetime.day == Time.now.day + 1
    datetime.strftime("%a, %b %e")
  end

end
