require 'rails_helper'

RSpec.describe Woods::Node, type: :model do

  describe "relations" do

    let(:player) { FactoryBot.create(:player) }

    let(:story) { FactoryBot.create(:story, player: player) }
    let(:storytree) { FactoryBot.create(:storytree, story: story) }

    let(:node1) { FactoryBot.create(:node, storytree: storytree) }
    let(:node2) { FactoryBot.create(:node, storytree: storytree) }

    let!(:box) { FactoryBot.create(:box, node: node1) }
    let!(:treelink)  { FactoryBot.create(:treelink, node: node1) }
    let!(:possibleitem)  { FactoryBot.create(:possibleitem, node: node1) }
    let!(:paintball)  { FactoryBot.create(:paintball, node: node1) }

    it "has a box" do
      expect( node1.box ).to eq(box)
    end

    it "has a treelink" do
      expect( node1.treelink ).to eq(treelink)
    end

    it "has a possibleitem" do
      expect( node1.possibleitem ).to eq(possibleitem)
    end

    it "has a paintball" do
      expect( node1.paintball ).to eq(paintball)
    end

  end

  describe "level" do

    let(:level_1_node) { FactoryBot.create(:node, tree_index: 1) }
    let(:level_2_node) { FactoryBot.create(:node, tree_index: 3) }
    let(:level_3_node) { FactoryBot.create(:node, tree_index: 4) }
    let(:level_8_node) { FactoryBot.create(:node, tree_index: 245) }

    it "calculates the node's level on the storytree" do
      expect( level_1_node.level ).to eq( 1 )
      expect( level_2_node.level ).to eq( 2 )
      expect( level_3_node.level ).to eq( 3 )
      expect( level_8_node.level ).to eq( 8 )
    end

  end

end
