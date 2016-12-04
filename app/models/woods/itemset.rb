class Woods::Itemset < ApplicationRecord

  has_many :items, dependent: :destroy
  has_many :possibleitems, dependent: :destroy
  has_many :boxes

  belongs_to :story

  validates_presence_of :name, :story

  def calculate_item_found(items_player_has)
    items_in_set = self.items.collect(&:id)

    possible_finds = items_in_set - items_player_has

    if possible_finds.size > 0
      begin
        Woods::Item.find( possible_finds[ Random.rand(possible_finds.size) ] )
      rescue
        raise "Cannot find item requested!"
        nil
      end
    end
  end

end
