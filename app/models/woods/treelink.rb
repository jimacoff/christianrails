class Woods::Treelink < ActiveRecord::Base
  belongs_to :node

  belongs_to :storytree, foreign_key: "linked_tree"

end
