require 'rails_helper'

RSpec.describe Woods::Storytree, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:story) { FactoryGirl.create(:story, player: player) }
    let!(:storytree1) { FactoryGirl.create(:storytree, story: story) }
    let!(:storytree2) { FactoryGirl.create(:storytree, story: story) }

    let!(:node1) { FactoryGirl.create(:node, storytree: storytree1) }
    let!(:node2) { FactoryGirl.create(:node, storytree: storytree1) }
    let!(:node3) { FactoryGirl.create(:node, storytree: storytree2) }
    let!(:node4) { FactoryGirl.create(:node, storytree: storytree2) }


  end


end
