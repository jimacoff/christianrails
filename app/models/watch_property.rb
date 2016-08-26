class WatchProperty < ActiveRecord::Base

  validates_presence_of :name, :url, :expected_response

end
