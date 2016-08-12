class Crm::Idea < ActiveRecord::Base
  belongs_to :assistant

  validates_presence_of :name

  STATUS_OPEN = 0
  STATUS_COMPLETE = 1
  STATUS_ABANDONED = 2
  STATUSES = [["Incomplete", 0], ["Complete", 1], ["Abandoned", 2]]

end
