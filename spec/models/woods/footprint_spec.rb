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

  describe "helper methods" do

    let(:player) { FactoryGirl.create(:player) }

    let(:scorecard) { FactoryGirl.create(:scorecard, player_id: player.id) }

    let(:storytree1) { FactoryGirl.create(:storytree, max_level: 1) }
    let(:storytree2) { FactoryGirl.create(:storytree, max_level: 3) }
    let(:storytree3) { FactoryGirl.create(:storytree, max_level: 5) }

    let(:footprint1) { FactoryGirl.create(:footprint, storytree: storytree1, scorecard: scorecard) }
    let(:footprint2) { FactoryGirl.create(:footprint, storytree: storytree2, scorecard: scorecard) }
    let(:footprint3) { FactoryGirl.create(:footprint, storytree: storytree3, scorecard: scorecard) }

    describe "construct_for_tree!" do

      it 'should construct proper footprints for various sized trees' do
        footprint1.construct_for_tree!
        expect( footprint1.footprint_data ).to eq('o')
        footprint2.construct_for_tree!
        expect( footprint2.footprint_data ).to eq('ooooooo') #7
        footprint3.construct_for_tree!
        expect( footprint3.footprint_data ).to eq('ooooooooooooooooooooooooooooooo') #31
      end

    end

    describe "scatter_objects_in_tree" do
      skip("TODO")
    end

    describe "step!" do

      it 'should step on the index requested' do
        footprint2.construct_for_tree!
        footprint2.step!(1)
        footprint2.step!(3)
        expect( footprint2.footprint_data ).to eq('xoxoooo')

        footprint2.step!(7)
        expect( footprint2.footprint_data ).to eq('xoxooox')

      end

      it 'should not step past the size of a tree' do
        skip("TODO")

      end

    end

    describe "print_at_index" do

      it "should retrieve the footprint at the given index" do
        footprint2.construct_for_tree!
        footprint2.step!(1)
        footprint2.step!(3)

        expect( footprint2.print_at_index(1) ).to eq( 'x' )
        expect( footprint2.print_at_index(2) ).to eq( 'o' )
        expect( footprint2.print_at_index(3) ).to eq( 'x' )
        expect( footprint2.print_at_index(4) ).to eq( 'o' )
      end

    end

    describe "decide_on_var_items" do
      skip("TODO")
    end

  end

end
