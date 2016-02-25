require 'rails_helper'

RSpec.describe Woods::Story, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:story) { FactoryGirl.create(:story, player: player) }
    let!(:storytree1) { FactoryGirl.create(:storytree, story: story) }
    let!(:storytree2) { FactoryGirl.create(:storytree, story: story) }

    let!(:node1) { FactoryGirl.create(:node, storytree: storytree1) }
    let!(:node2) { FactoryGirl.create(:node, storytree: storytree1) }
    let!(:node3) { FactoryGirl.create(:node, storytree: storytree2) }
    let!(:node4) { FactoryGirl.create(:node, storytree: storytree2) }

    it "should have many storytrees" do
      expect( story.storytrees.count ).to eq(2)
    end

    it "should have many nodes" do
      expect( story.nodes.count ).to eq(4)
    end

    it "should belong to a player" do
      expect( story.player ).to eq(player)
    end

  end


end
