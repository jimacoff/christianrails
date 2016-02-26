class Woods::Node < ActiveRecord::Base
  belongs_to :storytree
  belongs_to :moverule

  has_one :box,           dependent: :destroy
  has_one :paintball,     dependent: :destroy
  has_one :possibleitem,  dependent: :destroy
  has_one :treelink,      dependent: :destroy

  validates_presence_of :name, :storytree, :tree_index

  def add_accoutrements

    nodehash = self.as_json

    if self.paintball && self.paintball.enabled
      palette = self.paintball.palette
      p = { palette: { fore: palette.fore_colour, back: palette.back_colour, alt: palette.alt_colour} }
      nodehash.merge!( p )
    end

    if self.level == self.storytree.max_level

      if self.treelink && self.treelink.enabled
        t = { linked_node: treelink.linked_tree.get_first_node.id }
      else
        t = { linked_node: self.storytree.get_first_node.id }
      end
      nodehash.merge!( t )

    elsif self.level == self.storytree.max_level - 1
       # check moverule and provide a linked_node
       t = { linked_node: self.calculate_ending.id }
       nodehash.merge!( t )

    else
      left_node  = self.left
      right_node = self.right
      t = { left_link: left_node.id, right_link: right_node.id }
      nodehash.merge!( t )
    end

    pp nodehash
    nodehash
  end

  def level
    return 1 if (self.tree_index == 1)
    l_count = 1
    while (self.tree_index + 1) > 2**l_count do
      l_count += 1
    end
    l_count
  end

  def calculate_ending
    # TODO based on the moverule, calculate the proper ending node id to link to
    #if self.moverule.toggler?
      target_node = Random.rand(2) < 1 ? self.left : self.right
    #end

    # TODO THE REST


    target_node

  end

  def left
    begin
      Woods::Node.where(storytree_id: self.storytree_id, tree_index: self.tree_index * 2).first
    rescue
      nil
    end
  end

  def right
    begin
      Woods::Node.where(storytree_id: self.storytree_id, tree_index: (self.tree_index * 2) + 1).first
    rescue
      nil
    end
  end

end
