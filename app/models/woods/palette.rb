class Woods::Palette < ActiveRecord::Base
  belongs_to :story
  has_many :paintballs, dependent: :destroy

  validates_presence_of :name, :story, :fore_colour, :back_colour, :alt_colour

  BLACK = "#000000"
  WHITE = "#ffffff"
end
