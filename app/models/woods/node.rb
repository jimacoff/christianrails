class Woods::Node < ApplicationRecord

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
  MOVERULE_WIN_CHECK_1 = 7
  MOVERULE_WIN_CHECK_2 = 8
  MOVERULE_WIN_CHECK_3 = 9
  MOVERULE_WIN_CHECK_4 = 10
  MOVERULES = [
    [1, "50/50 toggler"],
    [2, "Left/right switch"],
    [3, "Perpetual item on left"],
    [4, "Variable item on left"],
    [5, "Single-use box on left"],
    [6, "Perpetual box on left"],
    [7, "Move left if win condition #1"],
    [8, "Move left if win condition #2"],
    [9, "Move left if win condition #3"],
    [10, "Move left if win condition #4"],
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

    when win_check?
      has_won_game?(player_id) ? left : right

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

  # check player inventory for required item
  def can_open_box?(player_id)
    if box = left.box
      itemset_required = box.itemset
      player = Woods::Player.find( player_id )
      player.has_item_in_itemset?( itemset_required.id )
    end
  end

  # check player inventory for all winning_condition items
  def has_won_game?(player_id)
    items_required = []
    self.storytree.story.items.each do |item|
      items_required << item.id if item.winning_condition == win_number
    end

    player = Woods::Player.find( player_id )
    items_required.each do |req_item_id|
      return false if !player.has_item?( req_item_id )
    end
    true
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

  def win_check?
    [MOVERULE_WIN_CHECK_1, MOVERULE_WIN_CHECK_2, MOVERULE_WIN_CHECK_3, MOVERULE_WIN_CHECK_4].include?( moverule_id )
  end

  # what have I even become
  def win_number
    if self.moverule_id == MOVERULE_WIN_CHECK_1
      1
    elsif self.moverule_id == MOVERULE_WIN_CHECK_2
      2
    elsif self.moverule_id == MOVERULE_WIN_CHECK_3
      3
    elsif self.moverule_id == MOVERULE_WIN_CHECK_4
      4
    end
  end

  # further helpers
  def item?
    perpetual_item? || variable_item?
  end

  def box?
    single_box? || perpetual_box?
  end

end
