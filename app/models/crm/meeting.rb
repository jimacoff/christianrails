class Crm::Meeting < ActiveRecord::Base
  belongs_to :assistant
  belongs_to :contact

  validates_presence_of :date_time, :name

  STATUS_FORTHCOMING = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Forthcoming", "Complete", "Bypassed"]

  # TODO modify to show time
  def personal_time
    return "Today"    if date_time.day == Time.now.day
    return "Tomorrow" if date_time.day == Time.now.day + 1
    date_time.strftime("%a, %b %e")
  end
end
