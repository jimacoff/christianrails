require "rails_helper"

RSpec.describe DownloadsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/downloads").to route_to("downloads#index")
    end

    it "routes to #create" do
      expect(:post => "/downloads").to route_to("downloads#create")
    end

  end
end
