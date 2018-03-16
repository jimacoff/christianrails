require 'rails_helper'

RSpec.describe Woods::Palette, type: :model do

  describe "relations" do

    let(:story) { FactoryBot.create(:story) }

    let(:palette) { FactoryBot.create(:palette, story: story) }

    let!(:paintball1) { FactoryBot.create(:paintball, palette: palette) }
    let!(:paintball2) { FactoryBot.create(:paintball, palette: palette) }

    it "should belong to a story" do
      expect( palette.story ).to eq(story)
    end

    it "should have many paintballs" do
      expect( palette.paintballs.count ).to eq(2)
    end

  end

end
