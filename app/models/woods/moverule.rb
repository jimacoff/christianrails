class Woods::Moverule < ActiveRecord::Base
  has_many :nodes

  validates_presence_of :name

  def toggler?
    self.name == "50/50 toggler"
  end

  def left_right_switch?
    self.name == "Left/right switch"
  end

  def perpetual_item?
    self.name == "Perpetual item on left"
  end

  def variable_item?
    self.name == "Variable item on left"
  end

  def single_box?
    self.name == "Single-use box on left"
  end

  def perpetual_box?
    self.name == "Perpetual box on left"
  end

end
