require 'rails_helper'

RSpec.describe Woods::Player, type: :model do

  describe "relations" do

    let(:user) { FactoryBot.create(:user) }

    let(:player) { FactoryBot.create(:player, user: user) }

    let!(:story1) { FactoryBot.create(:story, player: player) }
    let!(:story2) { FactoryBot.create(:story, player: player) }
    let!(:story3) { FactoryBot.create(:story, player: player) }

    let!(:find1) { FactoryBot.create(:find, player: player) }
    let!(:find2) { FactoryBot.create(:find, player: player) }

    let!(:scorecard) { FactoryBot.create(:scorecard, player: player) }
    let!(:footprint) { FactoryBot.create(:footprint, scorecard: scorecard) }

    it "has many finds" do
      expect( player.finds.count ).to eq(2)
    end

    it "has many scorecards" do
      expect( player.scorecards.count ).to eq(1)
    end

    it "has many footprints" do
      expect( player.footprints.count ).to eq(1)
    end

    it "belongs to a user" do
      expect( player.user ).to eq(user)
    end

    it "has many stories" do
      expect( player.stories.count ).to eq(3)
    end

  end

  describe "has_item?" do
    # TODO
  end

  describe "has_item_in_itemset?" do
    # TODO
  end

end
