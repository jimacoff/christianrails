class Crm::Assistant < ActiveRecord::Base
  has_many :contacts

  belongs_to :user
  validates_presence_of :user

  def username
    self.user.username
  end

end
