require 'rails_helper'

RSpec.describe Woods::Palette, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:palette) { FactoryGirl.create(:palette, player: player) }

    let!(:paintball1) { FactoryGirl.create(:paintball, palette: palette) }
    let!(:paintball2) { FactoryGirl.create(:paintball, palette: palette) }

    it "should belong to a player" do
      expect( palette.player ).to eq(player)
    end

    it "should have many paintballs" do
      expect( palette.paintballs.count ).to eq(2)
    end

  end

  describe "validations" do


  end

end
