class Woods::Footprint < ActiveRecord::Base
  belongs_to :scorecard, inverse_of: :footprint
  belongs_to :storytree

  belongs_to :player, inverse_of: :footprints
end
