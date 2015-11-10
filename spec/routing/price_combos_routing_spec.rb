require "rails_helper"

RSpec.describe PriceCombosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/price_combos").to route_to("price_combos#index")
    end

    it "routes to #new" do
      expect(:get => "/price_combos/new").to route_to("price_combos#new")
    end

    it "routes to #show" do
      expect(:get => "/price_combos/1").to route_to("price_combos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/price_combos/1/edit").to route_to("price_combos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/price_combos").to route_to("price_combos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/price_combos/1").to route_to("price_combos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/price_combos/1").to route_to("price_combos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/price_combos/1").to route_to("price_combos#destroy", :id => "1")
    end

  end
end
