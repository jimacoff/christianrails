class Crm::Task < ActiveRecord::Base
  belongs_to :assistant

  validates_presence_of :due_at, :name, :type_id

  STATUS_OPEN = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Open", "Complete", "Bypassed"]

  TYPE_ONETIME = 0
  TYPE_RECURRING_PERIOD = 1
  TYPES = [["One-time", 0], ["Recurs periodically", 1]]

end
