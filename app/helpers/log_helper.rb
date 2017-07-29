module LogHelper

  def record_event(location, desc)
    create_new_log_event(Log::TYPE_EVENT, location, desc)
  end

  def record_positive_event(location, desc)
    create_new_log_event(Log::TYPE_POSITIVE_EVENT, location, desc)
  end

  def record_bad_data(location, desc)
    create_new_log_event(Log::TYPE_BAD_DATA, location, desc)
  end

  def record_suspicious_event(location, desc)
    create_new_log_event(Log::TYPE_SUSPICIOUS_EVENT, location, desc)
  end

  def record_scheduled_event(location, desc)
    create_new_log_event(Log::TYPE_SCHEDULED_EVENT, location, desc)
  end

  def record_warning(location, desc)
    create_new_log_event(Log::TYPE_WARNING, location, desc)
  end

  def record_gifting(location, desc)
    create_new_log_event(Log::TYPE_GIFT, location, desc)
  end

  private

    def create_new_log_event(type_id, location, desc)
      Log.create(type_id: type_id, location: location, description: desc, user_id: safe_current_user_id)
    end

    def safe_current_user_id
      current_user.id if defined?(current_user) && current_user
    end

end
