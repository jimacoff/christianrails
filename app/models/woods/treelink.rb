class Woods::Treelink < ActiveRecord::Base
  belongs_to :node

  belongs_to :linked_tree, class_name: "Woods::Storytree", foreign_key: "linked_tree"

end
