require 'rails_helper'

RSpec.describe Woods::Node, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:story) { FactoryGirl.create(:story, player: player) }
    let(:storytree) { FactoryGirl.create(:storytree, story: story) }

    let(:node1) { FactoryGirl.create(:node, storytree: storytree) }
    let(:node2) { FactoryGirl.create(:node, storytree: storytree) }

    let!(:box) { FactoryGirl.create(:box, node: node1) }
    let!(:treelink)  { FactoryGirl.create(:treelink, node: node1) }
    let!(:possibleitem)  { FactoryGirl.create(:possibleitem, node: node1) }
    let!(:paintball)  { FactoryGirl.create(:paintball, node: node1) }

    let!(:moverule)  { FactoryGirl.create(:moverule) }

    it "should have a box" do
      expect( node1.box ).to eq(box)
    end

    it "should have a treelink" do
      expect( node1.treelink ).to eq(treelink)
    end

    it "should have a possibleitem" do
      expect( node1.possibleitem ).to eq(possibleitem)
    end

    it "should have a paintball" do
      expect( node1.paintball ).to eq(paintball)
    end

    it "should belong to a moverule" do
      node1.moverule = moverule
      node1.save

      expect( node1.moverule ).to eq(moverule)
    end

  end

  describe "validations" do


  end

  describe "level" do

    let(:level_1_node) { FactoryGirl.create(:node, tree_index: 1) }
    let(:level_2_node) { FactoryGirl.create(:node, tree_index: 3) }
    let(:level_3_node) { FactoryGirl.create(:node, tree_index: 4) }
    let(:level_8_node) { FactoryGirl.create(:node, tree_index: 245) }

    it "should calculate the node's level on the storytree" do
      expect( level_1_node.level ).to eq( 1 )
      expect( level_2_node.level ).to eq( 2 )
      expect( level_3_node.level ).to eq( 3 )
      expect( level_8_node.level ).to eq( 8 )
    end

  end

end
