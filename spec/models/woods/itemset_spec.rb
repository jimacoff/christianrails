require 'rails_helper'

RSpec.describe Woods::Itemset, type: :model do

  describe "relations" do

    let(:story) { FactoryBot.create(:story) }

    let(:itemset) { FactoryBot.create(:itemset, story: story) }

    let!(:item1) { FactoryBot.create(:item, itemset: itemset) }
    let!(:item2) { FactoryBot.create(:item, itemset: itemset) }
    let!(:item3) { FactoryBot.create(:item, itemset: itemset) }

    let!(:box1) { FactoryBot.create(:box, itemset: itemset) }
    let!(:box2) { FactoryBot.create(:box, itemset: itemset) }

    let!(:possibleitem1)  { FactoryBot.create(:possibleitem, itemset: itemset) }
    let!(:possibleitem2)  { FactoryBot.create(:possibleitem, itemset: itemset) }

    it "belongs to a story" do
      expect( itemset.story ).to eq(story)
    end

    it "has many items" do
      expect( itemset.items.count ).to eq(3)
    end

    it "has many possible_items" do
      expect( itemset.possibleitems.count ).to eq(2)
    end

    it "has many boxes" do
      expect( itemset.boxes.count ).to eq(2)
    end

  end

end
