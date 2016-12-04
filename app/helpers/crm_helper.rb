module CrmHelper

  def owns_assistant?(assistant)
    current_user && current_user.assistant && (current_user.assistant == assistant)
  end

  def verify_has_assistant
    redirect_to(root_path) unless current_assistant
  end

  def current_assistant
    current_user.assistant if current_user && current_user.assistant
  end

  def relative_time(datetime, include_time = false)
    return "Today"    + tack_on_time(include_time, datetime) if datetime.strftime("%a, %b %e") == (DateTime.current).strftime("%a, %b %e")
    return "Tomorrow" + tack_on_time(include_time, datetime) if datetime.strftime("%a, %b %e") == (DateTime.current + 1.day).strftime("%a, %b %e")
    if datetime < Time.current.to_datetime  # in the past!
      return "Yesterday" if datetime.strftime("%a, %b %e") == (DateTime.current - 1.day).strftime("%a, %b %e")
      return ((DateTime.current.to_i - datetime.to_i) / 86400).to_s + " days ago"
    end
    include_time ? datetime.strftime("%a, %b %e, %-I:%M %p") : datetime.strftime("%a, %b %e")
  end

  def tack_on_time(include_time, datetime)
    include_time ? " at #{datetime.strftime("%-I:%M %p")}" : ""
  end

end
