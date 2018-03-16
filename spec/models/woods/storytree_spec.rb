require 'rails_helper'

RSpec.describe Woods::Storytree, type: :model do

  describe "relations" do

    let(:player) { FactoryBot.create(:player) }

    let(:story) { FactoryBot.create(:story, player: player) }
    let!(:storytree) { FactoryBot.create(:storytree, story: story) }

    let!(:node1) { FactoryBot.create(:node, storytree: storytree) }
    let!(:node2) { FactoryBot.create(:node, storytree: storytree) }
    let!(:node3) { FactoryBot.create(:node, storytree: storytree) }
    let!(:node4) { FactoryBot.create(:node, storytree: storytree) }

    let!(:box) { FactoryBot.create(:box, node: node1) }
    let!(:possibleitem)  { FactoryBot.create(:possibleitem, node: node1) }
    let!(:paintball)  { FactoryBot.create(:paintball, node: node1) }

    let!(:footprint1)  { FactoryBot.create(:footprint, storytree: storytree) }
    let!(:footprint2)  { FactoryBot.create(:footprint, storytree: storytree) }

    it "belongs to a story" do
      expect( storytree.story ).to eq(story)
    end

    it "has many nodes" do
      expect( storytree.nodes.count ).to eq(4)
    end

    it "has many boxes" do
      expect( storytree.boxes.count ).to eq(1)
    end

    it "has many possibleitems" do
      expect( storytree.possibleitems.count ).to eq(1)
    end

    it "has many paintballs" do
      expect( storytree.paintballs.count ).to eq(1)
    end

    it "has many footprints" do
      expect( storytree.footprints.count ).to eq(2)
    end

  end

end
