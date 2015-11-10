class Release < ActiveRecord::Base
  belongs_to :product, inverse_of: :releases
  has_many :downloads, inverse_of: :release

  validates_presence_of :product, :format, :release_date 
  validates :format, inclusion: { in: %w(ePub PDF Kobo), message: "%{value} is not a valid format" }
end
