class Log < ApplicationRecord
  belongs_to :user, inverse_of: :logs, optional: true

  validates_presence_of :description, :location

  TYPE_EVENT = 0
  TYPE_POSITIVE_EVENT = 1
  TYPE_BAD_DATA = 2
  TYPE_SUSPICIOUS_EVENT = 3
  TYPE_SCHEDULED_EVENT = 4
  TYPE_WARNING = 5
  TYPE_GIFT = 6

  TYPES = ["Event", "Positive event", "Bad data", "Suspicious event", "Scheduled event", "Warning", "Free gift"]

  ## Locations
  STORE  = "Store"
  WOODS  = "BinaryWoods"
  BUTLER = "Wolf Butler"
  CRM    = "ghostCRM"
  BADGER = "This Badger"
  DRAWER = "Drawer"
  MELON  = "m3lon"

  BACKEND = "Back-end"
end
