class Woods::Scorecard < ActiveRecord::Base
  belongs_to :player, inverse_of: :scorecards
  has_one :footprint
  belongs_to :story
end
