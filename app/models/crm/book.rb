class Crm::Book < ApplicationRecord
  belongs_to :assistant

  validates_presence_of :title, :author

  STATUS_UNREAD = 0
  STATUS_READING = 1
  STATUS_READ = 2
  STATUSES = [["Want to read", 0], ["Currently reading", 1], ["Read", 2]]

  def is_ghostcrime?
    title == "Ghostcrime"
  end

end
