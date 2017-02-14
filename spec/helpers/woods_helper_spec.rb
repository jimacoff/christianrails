require 'rails_helper'

RSpec.describe WoodsHelper, type: :helper do

  describe "penultimate_level?" do

    it "identifies nodes in the penultimate level of a 4-level tree" do
      expect( penultimate_level?(4, 1) ).to be_falsy
      expect( penultimate_level?(4, 2) ).to be_falsy
      expect( penultimate_level?(4, 3) ).to be_falsy
      expect( penultimate_level?(4, 4) ).to be_truthy
      expect( penultimate_level?(4, 5) ).to be_truthy
      expect( penultimate_level?(4, 6) ).to be_truthy
      expect( penultimate_level?(4, 7) ).to be_truthy
      expect( penultimate_level?(4, 8) ).to be_falsy
      expect( penultimate_level?(4, 9) ).to be_falsy
      expect( penultimate_level?(4, 10) ).to be_falsy
      expect( penultimate_level?(4, 11) ).to be_falsy
      expect( penultimate_level?(4, 12) ).to be_falsy
      expect( penultimate_level?(4, 13) ).to be_falsy
      expect( penultimate_level?(4, 14) ).to be_falsy
      expect( penultimate_level?(4, 15) ).to be_falsy
    end

    it "identifies nodes in the penultimate level of a 5-level tree" do
      expect( penultimate_level?(5, 1) ).to be_falsy
      expect( penultimate_level?(5, 2) ).to be_falsy
      expect( penultimate_level?(5, 3) ).to be_falsy
      expect( penultimate_level?(5, 4) ).to be_falsy
      expect( penultimate_level?(5, 5) ).to be_falsy
      expect( penultimate_level?(5, 6) ).to be_falsy
      expect( penultimate_level?(5, 7) ).to be_falsy
      expect( penultimate_level?(5, 8) ).to be_truthy
      expect( penultimate_level?(5, 9) ).to be_truthy
      expect( penultimate_level?(5, 10) ).to be_truthy
      expect( penultimate_level?(5, 11) ).to be_truthy
      expect( penultimate_level?(5, 12) ).to be_truthy
      expect( penultimate_level?(5, 13) ).to be_truthy
      expect( penultimate_level?(5, 14) ).to be_truthy
      expect( penultimate_level?(5, 15) ).to be_truthy
      expect( penultimate_level?(5, 16) ).to be_falsy
      expect( penultimate_level?(5, 17) ).to be_falsy
    end

  end

end
