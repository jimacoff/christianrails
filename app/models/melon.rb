class Melon < ApplicationRecord
  TYPE_ORANGE = 0
  TYPE_YELLOW = 1
  TYPE_GREEN  = 2
  TYPES = [TYPE_ORANGE, TYPE_YELLOW, TYPE_GREEN]

  validates_presence_of :type_id
  validates :type_id, inclusion: { in: TYPES, message: "%{value} is not a valid melon" }
end
