class WatchProperty < ApplicationRecord

  validates_presence_of :name, :url, :expected_response

end
