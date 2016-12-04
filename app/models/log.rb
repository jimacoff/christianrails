class Log < ActiveRecord::Base
  belongs_to :user, inverse_of: :logs

  validates_presence_of :description, :location

  TYPE_EVENT = 0
  TYPE_POSITIVE_EVENT = 1
  TYPE_BAD_DATA = 2
  TYPE_SUSPICIOUS_EVENT = 3
  TYPE_SCHEDULED_EVENT = 4
  TYPE_WARNING = 5

  TYPES = ["Event", "Positive event", "Bad data", "Suspicious event", "Scheduled event", "Warning"]

  ## Locations
  STORE  = "Store"
  WOODS  = "BinaryWoods"
  BUTLER = "Wolf Butler"
  CRM    = "ghostCRM"
  BADGER = "This Badger"

  BACKEND = "Back-end"
end
