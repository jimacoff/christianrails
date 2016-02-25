require 'rails_helper'

RSpec.describe Woods::Find, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }
    let(:story) { FactoryGirl.create(:story, player: player) }
    let(:item) { FactoryGirl.create(:item) }

    let(:find) { FactoryGirl.create(:find, player: player, item: item, story: story) }


    it "should belong to a player" do
      expect( find.player ).to eq(player)
    end

    it "should belong to an item" do
      expect( find.item ).to eq(item)
    end

    it "should belong to a story" do
      expect( find.story ).to eq(story)
    end


  end

  describe "validations" do


  end

end
