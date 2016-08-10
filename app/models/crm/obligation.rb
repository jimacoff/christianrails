class Crm::Obligation < ActiveRecord::Base
  belongs_to :assistant
  belongs_to :contact

  validates_presence_of :due_at, :name

  STATUS_OPEN = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Open", "Complete", "Bypassed"]

  def personal_time
    return "Today"    if due_at.day == Time.now.day
    return "Tomorrow" if due_at.day == Time.now.day + 1
    due_at.strftime("%a, %b %e")
  end
end
