require 'rails_helper'

RSpec.describe Woods::Item, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }

    let(:itemset) { FactoryGirl.create(:itemset, player: player) }
    let(:item) { FactoryGirl.create(:item, itemset: itemset) }

    it "should belong to an itemset" do
      expect( item.itemset ).to eq(itemset)
    end

    it "should belong to a player" do
      expect( item.player ).to eq(player)
    end

  end


  describe "validations" do


  end

end
