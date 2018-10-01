require "rails_helper"

RSpec.describe Nugget, type: :model do

  let(:user)   { FactoryBot.create(:user) }
  let(:nugget) { FactoryBot.create(:nugget) }

  it "validates" do
    n = Nugget.new
    expect( n ).to_not be_valid
    expect( n.errors.messages.keys ).to include(:joke, :access_code, :serial_number)

    expect( n.errors.messages[:joke] ).to include("can't be blank")
    expect( n.errors.messages[:access_code] ).to include("can't be blank")
    expect( n.errors.messages[:serial_number] ).to include("can't be blank")

    n.joke = "IT IS JOKE"
    n.access_code = "this is the joke code"
    n.serial_number = 1

    expect( n ).to be_valid
  end

  it "can belong to a user who unlocked it" do
    nugget.unlocked_by = user
    nugget.save

    expect( nugget.unlocked_by    ).to eq( user )
    expect( nugget.unlocked_by_id ).to eq( user.id )
  end

end
