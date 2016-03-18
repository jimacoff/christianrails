class Woods::Scorecard < ActiveRecord::Base
  belongs_to :player, inverse_of: :scorecards
  has_many :footprints
  belongs_to :story

  validates_presence_of :player, :story
end