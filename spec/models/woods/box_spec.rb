require 'rails_helper'

RSpec.describe Woods::Box, type: :model do

  describe "relations" do

    let(:itemset) { FactoryGirl.create(:itemset) }

    let(:node1) { FactoryGirl.create(:node) }
    let(:node2) { FactoryGirl.create(:node) }

    let!(:box) { FactoryGirl.create(:box, node: node1, itemset: itemset) }

    it "should belong to a node" do
      expect( box.node ).to eq(node1)
    end

    it "should belong to an itemset" do
      expect( box.itemset ).to eq(itemset)
    end

  end

  describe "validations" do

  end


end
