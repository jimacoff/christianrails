class Release < ApplicationRecord

  FORMATS = %w(ePub PDF Kobo Book)

  belongs_to :product, inverse_of: :releases
  has_many :downloads, inverse_of: :release

  validates_presence_of :product, :format, :release_date
  validates :format, inclusion: { in: FORMATS, message: "%{value} is not a valid format" }
  validate :valid_physical_code

  private

  def valid_physical_code
    if self.format == "Book" && self.physical_code.blank?
      errors.add(:physical_code, "can't be blank")
    end
  end
end
