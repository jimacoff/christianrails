class Woods::Player < ActiveRecord::Base
  has_many :finds,        dependent: :destroy
  has_many :scorecards,   dependent: :destroy
  has_many :footprints,   through: :scorecards

  has_many :itemsets,     dependent: :destroy
  has_many :items,        through: :itemsets
  has_many :stories,     dependent: :destroy

  has_many :palettes,     dependent: :destroy

  belongs_to :user

  validates_presence_of :user

  def username
    self.user.username
  end
end
