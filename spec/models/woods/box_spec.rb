require 'rails_helper'

RSpec.describe Woods::Box, type: :model do

  describe "relations" do

    let(:itemset) { FactoryBot.create(:itemset) }

    let(:node1) { FactoryBot.create(:node) }
    let(:node2) { FactoryBot.create(:node) }

    let!(:box) { FactoryBot.create(:box, node: node1, itemset: itemset) }

    it "belongs to a node" do
      expect( box.node ).to eq(node1)
    end

    it "belongs to an itemset" do
      expect( box.itemset ).to eq(itemset)
    end

  end

end
