class Crm::Obligation < ActiveRecord::Base
  belongs_to :assistant
  belongs_to :contact

  validates_presence_of :due_at, :name

  STATUS_OPEN = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Open", "Complete", "Bypassed"]

end
