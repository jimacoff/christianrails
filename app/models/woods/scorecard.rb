class Woods::Scorecard < ActiveRecord::Base
  belongs_to :player
  belongs_to :story
end
