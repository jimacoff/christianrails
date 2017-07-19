module CrmHelper
  include LogHelper

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

  def send_out_daily_emails
    Crm::Assistant.where(email_me_daily: true).each do |assistant|
      if assistant.ripe_for_email?
        send_daily_summary( assistant )
      end
    end
  end

  private

    def send_daily_summary(assistant)
      attempts = 3
      begin
        Crm::ReminderMailer.daily_summary( assistant ).deliver_now
        create_new_mailout_record( assistant, Crm::Mailout::TYPE_DAILY_SUMMARY )
      rescue SocketError
        record_warning(Log::CRM, "Socket Error sending email for #{assistant.name}.")
        sleep 3
        retry if (attempts -= 1) >= 0
      end
    end

    def create_new_mailout_record(assistant, type)
      Crm::Mailout.create(assistant_id: assistant.id, type_id: type, status_id: Crm::Mailout::STATUS_COMPLETE)
    end

end
