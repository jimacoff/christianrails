class Woods::Palette < ActiveRecord::Base
  belongs_to :player
  has_many :paintballs, dependent: :destroy

end
