require 'rails_helper'

RSpec.describe Woods::Storytree, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:story) { FactoryGirl.create(:story, player: player) }
    let!(:storytree) { FactoryGirl.create(:storytree, story: story) }

    let!(:node1) { FactoryGirl.create(:node, storytree: storytree) }
    let!(:node2) { FactoryGirl.create(:node, storytree: storytree) }
    let!(:node3) { FactoryGirl.create(:node, storytree: storytree) }
    let!(:node4) { FactoryGirl.create(:node, storytree: storytree) }

    let!(:box) { FactoryGirl.create(:box, node: node1) }
    let!(:possibleitem)  { FactoryGirl.create(:possibleitem, node: node1) }
    let!(:paintball)  { FactoryGirl.create(:paintball, node: node1) }

    let!(:footprint1)  { FactoryGirl.create(:footprint, storytree: storytree) }
    let!(:footprint2)  { FactoryGirl.create(:footprint, storytree: storytree) }

    it "should belong to a story" do
      expect( storytree.story ).to eq(story)
    end

    it "should have many nodes" do
      expect( storytree.nodes.count ).to eq(4)
    end

    it "should have many boxes" do
      expect( storytree.boxes.count ).to eq(1)
    end

    it "should have many possibleitems" do
      expect( storytree.possibleitems.count ).to eq(1)
    end

    it "should have many paintballs" do
      expect( storytree.paintballs.count ).to eq(1)
    end

    it "should have many footprints" do
      expect( storytree.footprints.count ).to eq(2)
    end

  end

  describe "validations" do


  end

end
