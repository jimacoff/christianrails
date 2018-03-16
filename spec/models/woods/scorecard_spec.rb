require 'rails_helper'

RSpec.describe Woods::Scorecard, type: :model do

  describe "relations" do

    let(:player) { FactoryBot.create(:player) }
    let(:story) { FactoryBot.create(:story, player: player) }

    let!(:scorecard) { FactoryBot.create(:scorecard, story: story, player: player) }

    it "belongs to a player" do
      expect( scorecard.player ).to eq(player)
    end

    it "belongs to a story" do
      expect( scorecard.story ).to eq(story)
    end

  end

end
