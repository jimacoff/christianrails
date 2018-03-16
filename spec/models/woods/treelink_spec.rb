require 'rails_helper'

RSpec.describe Woods::Treelink, type: :model do

  describe "relations" do

    let(:storytree) { FactoryBot.create(:storytree) }

    let(:node) { FactoryBot.create(:node) }

    let!(:treelink)  { FactoryBot.create(:treelink, node: node, linked_tree: storytree) }

    it "belongs to node" do
      expect( treelink.node ).to eq(node)
    end

    it "belongs to storytree, as linked_tree" do
      expect( treelink.linked_tree ).to eq(storytree)
    end

  end

end
