class Woods::Node < ActiveRecord::Base

  belongs_to :storytree

  has_one :box,           dependent: :destroy
  has_one :paintball,     dependent: :destroy
  has_one :possibleitem,  dependent: :destroy
  has_one :treelink,      dependent: :destroy

  validates_presence_of :storytree, :tree_index

  MOVERULE_TOGGLER = 1
  MOVERULE_LR_SWITCH = 2
  MOVERULE_PERPETUAL_ITEM = 3
  MOVERULE_VARIABLE_ITEM = 4
  MOVERULE_SINGlE_BOX = 5
  MOVERULE_PERPETUAL_BOX = 6
  MOVERULES = [
    [1, "50/50 toggler"],
    [2, "Left/right switch"],
    [3, "Perpetual item on left"],
    [4, "Variable item on left"],
    [5, "Single-use box on left"],
    [6, "Perpetual box on left"]
  ]

  def add_accoutrements_and_make_json!(player_id = nil, footprint = nil, item_found = nil)
    nodehash = self.as_json

    if self.paintball && self.paintball.enabled
      palette = self.paintball.palette
      nodehash.merge!( { palette: { fore: palette.fore_colour, back: palette.back_colour, alt: palette.alt_colour} } )
    end

    if item_found
      nodehash.merge!( { item_found: { name: item_found.name, value: item_found.value, legend: item_found.legend, image: item_found.image } } )
    end

    if self.level == self.storytree.max_level
      if self.treelink && self.treelink.enabled
        l = { linked_node: treelink.linked_tree.get_first_node.id }
      else
        l = { linked_node: self.storytree.get_first_node.id }
      end
      nodehash.merge!( l )

    elsif self.level == self.storytree.max_level - 1
       nodehash.merge!( { linked_node: self.calculate_ending(footprint, player_id).id } )
    else
      left_node  = self.left
      right_node = self.right
      nodehash.merge!( { left_link: left_node.id, right_link: right_node.id } )
    end

    nodehash.merge!( { tree_size: ( 2 ** self.level ) - 1 } )
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

  def calculate_ending(footprint, player_id)
    case
    when toggler?
      Random.rand(2) < 1 ? left : right

    when left_right_switch?
      footprint.been_to_index?(left_index) ? right : left

    when perpetual_item?
      footprint.been_to_index?(left_index) ? right : left

    when variable_item?
      footprint.item_at_index?(left_index) ? left : right

    when single_box?
      footprint.been_to_index?(left_index) ? right : can_open_box?(player_id) ? left : right

    when perpetual_box?
      can_open_box?(player_id) ? left : right

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

private

  def can_open_box?(player_id)
    if box = left.box
      itemset_required = box.itemset
      player = Woods::Player.find(player_id)
      player.has_item_in_itemset?(itemset_required.id)
    end
  end

  ## moverule helpers

  def toggler?
    moverule_id == MOVERULE_TOGGLER
  end

  def left_right_switch?
    moverule_id == MOVERULE_LR_SWITCH
  end

  def perpetual_item?
    moverule_id == MOVERULE_PERPETUAL_ITEM
  end

  def variable_item?
    moverule_id == MOVERULE_VARIABLE_ITEM
  end

  def single_box?
    moverule_id == MOVERULE_SINGlE_BOX
  end

  def perpetual_box?
    moverule_id == MOVERULE_PERPETUAL_BOX
  end

  # further helpers
  def item?
    perpetual_item? || variable_item?
  end

  def box?
    single_box? || perpetual_box?
  end

end
