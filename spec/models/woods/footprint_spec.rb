require 'rails_helper'

RSpec.describe Woods::Footprint, type: :model do

  describe "relations" do

    let(:storytree) { FactoryBot.create(:storytree) }
    let(:scorecard) { FactoryBot.create(:scorecard) }

    let(:footprint) { FactoryBot.create(:footprint, storytree: storytree, scorecard: scorecard) }

    it "belongs to a scorecard" do
      expect( footprint.scorecard ).to eq(scorecard)
    end

    it "belongs to a storytree" do
      expect( footprint.storytree ).to eq(storytree)
    end

  end

  describe "helper methods" do

    let(:player) { FactoryBot.create(:player) }

    let(:scorecard) { FactoryBot.create(:scorecard, player_id: player.id) }

    let(:storytree1) { FactoryBot.create(:storytree, max_level: 1) }
    let(:storytree2) { FactoryBot.create(:storytree, max_level: 3) }
    let(:storytree3) { FactoryBot.create(:storytree, max_level: 5) }

    let(:footprint1) { FactoryBot.create(:footprint, storytree: storytree1, scorecard: scorecard) }
    let(:footprint2) { FactoryBot.create(:footprint, storytree: storytree2, scorecard: scorecard) }
    let(:footprint3) { FactoryBot.create(:footprint, storytree: storytree3, scorecard: scorecard) }

    describe "construct_for_tree!" do

      it 'constructs proper footprints for various sized trees' do
        footprint1.construct_for_tree!
        expect( footprint1.footprint_data ).to eq('o')
        footprint2.construct_for_tree!
        expect( footprint2.footprint_data ).to eq('ooooooo') #7
        footprint3.construct_for_tree!
        expect( footprint3.footprint_data ).to eq('ooooooooooooooooooooooooooooooo') #31
      end

    end

    describe "step!" do

      it 'steps on the index requested' do
        footprint2.construct_for_tree!
        footprint2.step!(1)
        footprint2.step!(3)
        expect( footprint2.footprint_data ).to eq('xoxoooo')

        footprint2.step!(7)
        expect( footprint2.footprint_data ).to eq('xoxooox')

      end

    end

    describe "print_at_index" do

      it "retrieves the footprint at the given index" do
        footprint2.construct_for_tree!
        footprint2.step!(1)
        footprint2.step!(3)

        expect( footprint2.print_at_index(1) ).to eq( 'x' )
        expect( footprint2.print_at_index(2) ).to eq( 'o' )
        expect( footprint2.print_at_index(3) ).to eq( 'x' )
        expect( footprint2.print_at_index(4) ).to eq( 'o' )
      end

    end

  end

end
