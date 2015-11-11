require "rails_helper"

RSpec.describe DownloadsController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "/downloads").to route_to("downloads#create")
    end

  end
end
