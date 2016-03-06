class Woods::Footprint < ActiveRecord::Base
  belongs_to :scorecard, inverse_of: :footprints
  belongs_to :storytree

  belongs_to :player, inverse_of: :footprints

  validates_presence_of :scorecard, :storytree

  def construct_for_tree!
    self.footprint_data = 'o' * ( 2**self.storytree.max_level - 1)
    self.save
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

end
