class Woods::Node < ActiveRecord::Base
  has_one :box,           dependent: :destroy
  belongs_to :moverule
  has_one :paintball,     dependent: :destroy
  has_one :possibleitem,  dependent: :destroy
  has_one :treelink,      dependent: :destroy

  belongs_to :storytree
  belongs_to :story

end
