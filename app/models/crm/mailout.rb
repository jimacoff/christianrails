class Crm::Mailout < ApplicationRecord
  belongs_to :assistant

  validates_presence_of :assistant, :type_id

  STATUS_INCOMPLETE = 0
  STATUS_COMPLETE = 1
  STATUS_FAILED = 2
  STATUSES = ["Incomplete", "Complete", "Failed"]

  TYPE_DAILY_SUMMARY = 1

end
