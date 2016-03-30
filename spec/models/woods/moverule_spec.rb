require 'rails_helper'

RSpec.describe Woods::Moverule, type: :model do

  describe "relations" do

    let(:moverule)  { FactoryGirl.create(:moverule) }

    let!(:node1) { FactoryGirl.create(:node, moverule: moverule) }
    let!(:node2) { FactoryGirl.create(:node, moverule: moverule) }

    it "should have many nodes" do
      expect( moverule.nodes.count ).to eq(2)
    end

  end

end
