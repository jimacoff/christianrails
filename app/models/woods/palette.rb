class Woods::Palette < ActiveRecord::Base

  BLACK = "#000000"
  WHITE = "#ffffff"

  belongs_to :player
  has_many :paintballs, dependent: :destroy

  validates_presence_of :name, :player, :fore_colour, :back_colour, :alt_colour
end
