class Nugget < ApplicationRecord
  belongs_to :unlocked_by, class_name: "User", optional: true

  validates_presence_of :joke, :access_code, :serial_number
  validates_uniqueness_of :serial_number

  def unlocked?
    !!self.unlocked_at
  end

  def calc_price
    self.serial_number <= 100 ? 10_00 : 20_00
  end

end
