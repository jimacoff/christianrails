class Woods::Footprint < ActiveRecord::Base
  belongs_to :scorecard, inverse_of: :footprints
  belongs_to :storytree

  belongs_to :player, inverse_of: :footprints

  validates_presence_of :scorecard, :storytree

  def construct_for_tree!
    self.footprint_data = 'o' * ( 2**self.storytree.max_level - 1)
    scatter_objects_in_tree
    self.save
  end

  def scatter_objects_in_tree
    var_items = []
    self.storytree.possibleitems.includes(:node).where(enabled: true).each do |poss_item|
      if poss_item.perpetual
        self.footprint_data[poss_item.node.tree_index - 1] = 'i'
      else
        var_items << poss_item.node.tree_index
      end
    end

    solidified_item_tree_indexes = decide_on_var_items(var_items)
    solidified_item_tree_indexes.each do |sol|
      self.footprint_data[sol] = 'i'
    end
  end

  def step!(tree_index)
    if self.footprint_data.size >= tree_index
      self.footprint_data[tree_index - 1] = 'x'
      self.save
    else
      # TODO something wrong
      raise "MISSTEP!"
    end
  end

  def print_at_index(index)
    self.footprint_data[ index - 1 ]
  end

  def been_to_index?(index)
    print_at_index(index) == 'x'
  end

  def item_at_index?(index)
    print_at_index(index) == 'i'
  end

  def decide_on_var_items(var_items)
    solidified_items = []

    if var_items.size > 0
      try_i = var_items[0]

      level_of_items = 1
      if try_i > 1
        while (try_i + 1) > 2**level_of_items do
          level_of_items += 1
        end
      end

      if level_of_items == 3
        # special case -- only 1 item possible in 2 spots
        solidified_items << var_items[ Random.rand(var_items.size) ]
      else
        # iterate through each group of 8 endings & choose a variable item
        nodes_in_level = 2 ** (level_of_items - 1)
        sections_in_level = nodes_in_level / 8

        sections_in_level.times do |i|
          starting_index = (nodes_in_level) + (8 * i)
          ending_index = starting_index + 7
          range = starting_index..ending_index

          items_in_this_range = var_items & range.to_a

          solidified_items << items_in_this_range[ Random.rand(items_in_this_range.size) ]
        end
      end
    end
    solidified_items
  end

end
