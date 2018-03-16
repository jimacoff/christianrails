require 'rails_helper'

RSpec.describe Woods::Story, type: :model do

  describe "relations" do

    let(:player) { FactoryBot.create(:player) }

    let(:story) { FactoryBot.create(:story, player: player) }
    let!(:storytree1) { FactoryBot.create(:storytree, story: story) }
    let!(:storytree2) { FactoryBot.create(:storytree, story: story) }

    let!(:node1) { FactoryBot.create(:node, storytree: storytree1) }
    let!(:node2) { FactoryBot.create(:node, storytree: storytree1) }
    let!(:node3) { FactoryBot.create(:node, storytree: storytree2) }
    let!(:node4) { FactoryBot.create(:node, storytree: storytree2) }

    let!(:itemset) { FactoryBot.create(:itemset, story: story) }

    let!(:item1) { FactoryBot.create(:item, itemset: itemset) }
    let!(:item2) { FactoryBot.create(:item, itemset: itemset) }

    let!(:palette1)  { FactoryBot.create(:palette, story: story) }
    let!(:palette2)  { FactoryBot.create(:palette, story: story) }

    it "should have many storytrees" do
      expect( story.storytrees.count ).to eq(2)
    end

    it "should have many nodes" do
      expect( story.nodes.count ).to eq(4)
    end

    it "should belong to a player" do
      expect( story.player ).to eq(player)
    end

    it "should have many itemsets" do
      expect( story.itemsets.count ).to eq(1)
    end

    it "should have many items" do
      expect( story.items.count ).to eq(2)
    end

    it "should have many palettes" do
      expect( story.palettes.count ).to eq(2)
    end

  end

end
