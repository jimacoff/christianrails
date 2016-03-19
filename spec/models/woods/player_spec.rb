require 'rails_helper'

RSpec.describe Woods::Player, type: :model do

  describe "relations" do

    let(:user) { FactoryGirl.create(:user) }

    let(:player) { FactoryGirl.create(:player, user: user) }

    let!(:story1) { FactoryGirl.create(:story, player: player) }
    let!(:story2) { FactoryGirl.create(:story, player: player) }
    let!(:story3) { FactoryGirl.create(:story, player: player) }

    let!(:find1) { FactoryGirl.create(:find, player: player) }
    let!(:find2) { FactoryGirl.create(:find, player: player) }

    let!(:scorecard) { FactoryGirl.create(:scorecard, player: player) }
    let!(:footprint) { FactoryGirl.create(:footprint, scorecard: scorecard) }

    it "should have many finds" do
      expect( player.finds.count ).to eq(2)
    end

    it "should have many scorecards" do
      expect( player.scorecards.count ).to eq(1)
    end

    it "should have many footprints" do
      expect( player.footprints.count ).to eq(1)
    end

    it "should belong to a user" do
      expect( player.user ).to eq(user)
    end

    it "should have many stories" do
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
