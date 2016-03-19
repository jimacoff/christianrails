class MoveNonDfItemsetsToProperStories < ActiveRecord::Migration
  def change
    # CB items
    i = Woods::Itemset.where('id > ?', 90)
    i.each do |itemset|
      itemset.story_id = 15
      itemset.save
    end

    # RT
    set = Woods::Itemset.find(75)
    set.story_id = 29
    set.save

  end
end
