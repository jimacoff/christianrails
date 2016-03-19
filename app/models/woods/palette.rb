class Woods::Palette < ActiveRecord::Base

  BLACK = "#000000"
  WHITE = "#ffffff"

  belongs_to :story
  has_many :paintballs, dependent: :destroy

  validates_presence_of :name, :story, :fore_colour, :back_colour, :alt_colour
end
