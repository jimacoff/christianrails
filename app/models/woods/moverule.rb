class Woods::Moverule < ActiveRecord::Base
  has_many :nodes

  belongs_to :storytree
  belongs_to :story
end
