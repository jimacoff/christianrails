class Crm::Meeting < ActiveRecord::Base
  belongs_to :assistant
  belongs_to :contact

  validates_presence_of :date_time, :name

  STATUS_FORTHCOMING = 0
  STATUS_COMPLETE = 1
  STATUS_BYPASSED = 2
  STATUSES = ["Forthcoming", "Complete", "Bypassed"]

  def time=(val)
    dt = val.to_datetime
    int_time = dt.to_i - dt.beginning_of_day.to_i
    self.date_time += int_time
  end

  def time
    self.date_time ? self.date_time : DateTime.new(2000,01,01,9,0)
  end

end
