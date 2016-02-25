require 'rails_helper'

RSpec.describe Woods::Itemset, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:itemset) { FactoryGirl.create(:itemset, player: player) }

    let!(:item1) { FactoryGirl.create(:item, itemset: itemset) }
    let!(:item2) { FactoryGirl.create(:item, itemset: itemset) }
    let!(:item3) { FactoryGirl.create(:item, itemset: itemset) }

    let!(:box1) { FactoryGirl.create(:box, itemset: itemset) }
    let!(:box2) { FactoryGirl.create(:box, itemset: itemset) }

    let!(:possibleitem1)  { FactoryGirl.create(:possibleitem, itemset: itemset) }
    let!(:possibleitem2)  { FactoryGirl.create(:possibleitem, itemset: itemset) }

    it "should belong to a player" do
      expect( itemset.player ).to eq(player)
    end

    it "should have many items" do
      expect( itemset.items.count ).to eq(3)
    end

    it "should have many possible_items" do
      expect( itemset.possibleitems.count ).to eq(2)
    end

    it "should have many boxes" do
      expect( itemset.boxes.count ).to eq(2)
    end

  end

  describe "validations" do


  end

end
