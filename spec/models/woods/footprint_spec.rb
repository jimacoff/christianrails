require 'rails_helper'

RSpec.describe Woods::Footprint, type: :model do

  describe "relations" do

    let(:storytree) { FactoryGirl.create(:storytree) }
    let(:scorecard) { FactoryGirl.create(:scorecard) }

    let(:footprint) { FactoryGirl.create(:footprint, storytree: storytree, scorecard: scorecard) }

    it "should belong to a scorecard" do
      expect( footprint.scorecard ).to eq(scorecard)
    end

    it "should belong to a storytree" do
      expect( footprint.storytree ).to eq(storytree)
    end

  end

  describe "validations" do


  end

end
