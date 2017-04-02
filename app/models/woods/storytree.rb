class Woods::Storytree < ApplicationRecord
  belongs_to :story
  has_many :nodes, dependent: :destroy

  has_many :boxes, through: :nodes
  has_many :paintballs, through: :nodes
  has_many :possibleitems, through: :nodes

  has_many :treelinks, foreign_key: "linked_tree_id"

  has_many :footprints

  validates_presence_of :name, :max_level, :story

  def get_first_node
    Woods::Node.includes(:paintball, :treelink, :possibleitem, :box).where(storytree_id: self.id, tree_index: 1).first
  end

  def node_popularity
    statsprint = []
    footprints.each do |print|
      i = 0
      print.footprint_data.length.times do
        if ['x', 'y'].include?(print.footprint_data[i])
          statsprint[ i ] = statsprint[ i ] ? statsprint[ i ] + 1 : 1
        else
          statsprint[ i ] = statsprint[ i ] ? statsprint[ i ] : 0
        end
        i += 1
      end
    end
    statsprint.each_with_index do |pr, i|
      statsprint[i] = 0 if !pr
    end
    statsprint
  end

  def generate_popularity_tree
    tree_string = ""
    level_sizes = nodes_at_level
    pos_on_level = 0; level_num = 0

    node_popularity.each do |pop|
      tree_string << (pop ? pop.to_s : "x") << " "
      pos_on_level += 1
      if pos_on_level >= level_sizes[level_num]
        tree_string << "\n\n"
        level_num += 1
        pos_on_level = 0
      end
    end
    tree_string
  end

  def most_popular_nodes_by_level
    most_popular_nodes = []
    level_sizes = nodes_at_level
    pos_on_level = 0; level_num = 0
    popularities_at_level = []

    node_popularity.each do |pop|
      popularities_at_level << pop
      pos_on_level += 1

      if pos_on_level >= level_sizes[level_num]
        max_val = popularities_at_level.max
        most_popular_nodes[level_num] = []
        indexes_of_most_popular = popularities_at_level.each_index.select{ |x| popularities_at_level[x] == max_val }
        indexes_of_most_popular.each do |most_pop_index|
          tree_index_of_pop = (2 ** level_num) + most_pop_index
          most_popular_nodes[level_num] << get_node_at_index(tree_index_of_pop).name
        end
        popularities_at_level = []
        level_num += 1
        pos_on_level = 0
      end
    end
    most_popular_nodes
  end

  private

    def nodes_at_level
      nodes_at_level = []
      exp = 0
      max_level.times do
        nodes_at_level[ exp ] = 2 ** exp
        exp += 1
      end
      nodes_at_level
    end

    def get_node_at_index(index)
      nodes.where(tree_index: index).first
    end

end
