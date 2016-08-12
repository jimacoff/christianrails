class Crm::Meeting < ActiveRecord::Base
  belongs_to :assistant
  belongs_to :contact

  validates_presence_of :date_time, :name

  STATUS_FORTHCOMING = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Forthcoming", "Complete", "Bypassed"]

end
