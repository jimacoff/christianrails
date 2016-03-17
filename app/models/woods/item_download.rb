class Woods::ItemDownload < ActiveRecord::Base
  belongs_to :item, inverse_of: :item_downloads
  belongs_to :player, inverse_of: :item_downloads

  validates_presence_of :item, :player

  LIMIT = 5

end
