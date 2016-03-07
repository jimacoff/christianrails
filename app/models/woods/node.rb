class Woods::Node < ActiveRecord::Base


  belongs_to :storytree
  belongs_to :moverule

  has_one :box,           dependent: :destroy
  has_one :paintball,     dependent: :destroy
  has_one :possibleitem,  dependent: :destroy
  has_one :treelink,      dependent: :destroy

  validates_presence_of :name, :storytree, :tree_index

  def add_accoutrements_and_make_json!(items_player_has = [], footprint = nil)

    nodehash = self.as_json

    if self.paintball && self.paintball.enabled
      palette = self.paintball.palette
      nodehash.merge!( { palette: { fore: palette.fore_colour, back: palette.back_colour, alt: palette.alt_colour} } )
    end

    if self.possibleitem && self.possibleitem.enabled && footprint.item_at_index?(nodehash['tree_index'])
      itemset_found = Woods::Itemset.find( self.possibleitem.itemset_id )
      found = itemset_found.calculate_item_id_found(items_player_has)
      nodehash.merge!( { item_found: { name: found.name, value: found.value, legend: found.legend, image: found.image } } )
    end

    if self.level == self.storytree.max_level

      if self.treelink && self.treelink.enabled
        l = { linked_node: treelink.linked_tree.get_first_node.id }
      else
        l = { linked_node: self.storytree.get_first_node.id }
      end
      nodehash.merge!( l )

    elsif self.level == self.storytree.max_level - 1
       nodehash.merge!( { linked_node: self.calculate_ending(footprint).id } )
    else
      left_node  = self.left
      right_node = self.right
      nodehash.merge!( { left_link: left_node.id, right_link: right_node.id } )
    end

    nodehash.merge!( { tree_size: ( 2 ** self.level ) - 1 } )

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

  def calculate_ending(footprint)
    case
    when self.moverule.toggler?
      Random.rand(2) < 1 ? self.left : self.right
    when self.moverule.left_right_switch?
      footprint.been_to_index?(self.left_index) ? self.right : self.left

    when self.moverule.perpetual_item?
      footprint.been_to_index?(left_index) ? self.right : self.left
    when self.moverule.variable_item?
      footprint.item_at_index?(left_index) ? self.left : self.right
    when self.moverule.box?
      calc_box_node
    else
      raise "ERROR: Unknown moverule!"
    end
  end

  def left
    begin
      Woods::Node.where(storytree_id: self.storytree_id, tree_index: left_index).first
    rescue
      nil
    end
  end

  def right
    begin
      Woods::Node.where(storytree_id: self.storytree_id, tree_index: right_index).first
    rescue
      nil
    end
  end

  def left_index
    self.tree_index * 2
  end

  def right_index
    (self.tree_index * 2) + 1
  end

  def calc_box_node
    if self.moverule.single_box?
      # TODO determine if box opened
    elsif self.moverule.perpetual_box?
      # TODO determine if you have item in set required
    end
  end

end
