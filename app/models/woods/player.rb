class Woods::Player < ActiveRecord::Base
  has_many :finds,        dependent: :destroy
  has_many :scorecards,   dependent: :destroy
  has_many :footprints,   through: :scorecards

  has_many :itemsets,     dependent: :destroy
  has_many :items,        through: :itemsets

  has_many :palettes,     dependent: :destroy
end
