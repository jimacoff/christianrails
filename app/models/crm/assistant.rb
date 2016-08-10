class Crm::Assistant < ActiveRecord::Base
  has_many :contacts
  has_many :obligations

  belongs_to :user
  validates_presence_of :user

  PERSONALITIES = ["Servile"]

  def username
    self.user.username
  end

end
