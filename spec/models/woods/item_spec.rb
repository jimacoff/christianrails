require 'rails_helper'

RSpec.describe Woods::Item, type: :model do

  describe "relations" do

    let(:story) { FactoryBot.create(:story) }

    let(:itemset) { FactoryBot.create(:itemset, story: story) }
    let(:item) { FactoryBot.create(:item, itemset: itemset) }

    it "should belong to an itemset" do
      expect( item.itemset ).to eq(itemset)
    end

    it "should belong to a story" do
      expect( item.story ).to eq(story)
    end

  end

end
