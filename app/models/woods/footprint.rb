class Woods::Footprint < ActiveRecord::Base
  belongs_to :scorecard
  belongs_to :storytree
end
