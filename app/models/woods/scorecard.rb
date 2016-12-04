class Woods::Scorecard < ApplicationRecord
  belongs_to :player, inverse_of: :scorecards
  has_many :footprints, dependent: :destroy
  belongs_to :story

  validates_presence_of :player, :story
end
