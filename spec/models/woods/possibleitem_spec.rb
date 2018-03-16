require 'rails_helper'

RSpec.describe Woods::Possibleitem, type: :model do

  describe "relations" do

    let(:node) { FactoryBot.create(:node) }

    let(:itemset) { FactoryBot.create(:itemset) }

    let!(:possibleitem) { FactoryBot.create(:possibleitem, node: node, itemset: itemset) }

    it "should belong to a node" do
      expect( possibleitem.node ).to eq(node)
    end

    it "should belong to an itemset" do
      expect( possibleitem.itemset ).to eq(itemset)
    end

  end

end
