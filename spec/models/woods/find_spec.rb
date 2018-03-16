require 'rails_helper'

RSpec.describe Woods::Find, type: :model do

  describe "relations" do

    let(:player) { FactoryBot.create(:player) }
    let(:story) { FactoryBot.create(:story, player: player) }
    let(:item) { FactoryBot.create(:item) }

    let(:find) { FactoryBot.create(:find, player: player, item: item, story: story) }


    it "belongs to a player" do
      expect( find.player ).to eq(player)
    end

    it "belongs to an item" do
      expect( find.item ).to eq(item)
    end

    it "belongs to a story" do
      expect( find.story ).to eq(story)
    end

  end

end
