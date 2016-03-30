require 'rails_helper'

RSpec.describe Woods::Paintball, type: :model do

  describe "relations" do

    let(:node) { FactoryGirl.create(:node) }
    let(:palette) { FactoryGirl.create(:palette) }

    let!(:paintball) { FactoryGirl.create(:paintball, node: node, palette: palette) }

    it "should belong to a node" do
      expect( paintball.node ).to eq(node)
    end

    it "should belong to a palette" do
      expect( paintball.palette ).to eq(palette)
    end

  end

end
