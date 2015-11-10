class Download < ActiveRecord::Base
  belongs_to :release, inverse_of: :downloads
  belongs_to :user, inverse_of: :downloads

  validates_presence_of :release, :user

end
