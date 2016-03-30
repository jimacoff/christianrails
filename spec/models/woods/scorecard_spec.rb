require 'rails_helper'

RSpec.describe Woods::Scorecard, type: :model do

  describe "relations" do

    let(:player) { FactoryGirl.create(:player) }
    let(:story) { FactoryGirl.create(:story, player: player) }

    let!(:scorecard) { FactoryGirl.create(:scorecard, story: story, player: player) }

    it "should belong to a player" do
      expect( scorecard.player ).to eq(player)
    end

    it "should belong to a story" do
      expect( scorecard.story ).to eq(story)
    end

  end

end
