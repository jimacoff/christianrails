require "rails_helper"

RSpec.describe StagedPurchasesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/staged_purchases").to route_to("staged_purchases#index")
    end

    it "routes to #create" do
      expect(:post => "/staged_purchases").to route_to("staged_purchases#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/staged_purchases/1").to route_to("staged_purchases#destroy", :id => "1")
    end

  end
end
