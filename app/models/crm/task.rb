class Crm::Task < ActiveRecord::Base
  belongs_to :assistant

  validates_presence_of :due_at, :name, :type_id

  STATUS_OPEN = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Open", "Complete", "Bypassed"]

  TYPE_ONETIME = 0
  TYPE_RECURRING_PERIOD = 1
  TYPE_RECURRING_WEEKDAY = 2
  TYPE_RECURRING_MONTHDAY = 3
  TYPES = [["One-time", 0], ["Recurs periodically", 1], ["Recurs on weekday", 2], ["Recurs on calendar day", 3]]

  def personal_time
    return "Today"    if due_at.day == Time.now.day
    return "Tomorrow" if due_at.day == Time.now.day + 1
    due_at.strftime("%a, %b %e")
  end
end
