require 'rails_helper'

RSpec.describe Woods::Item, type: :model do

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

  end


end
