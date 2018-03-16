require 'rails_helper'

RSpec.describe Woods::Paintball, type: :model do

  describe "relations" do

    let(:node) { FactoryBot.create(:node) }
    let(:palette) { FactoryBot.create(:palette) }

    let!(:paintball) { FactoryBot.create(:paintball, node: node, palette: palette) }

    it "belongs to a node" do
      expect( paintball.node ).to eq(node)
    end

    it "belongs to a palette" do
      expect( paintball.palette ).to eq(palette)
    end

  end

end
