require "rails_helper"

RSpec.describe PurchasesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/purchases").to route_to("purchases#index")
    end

  end
end
