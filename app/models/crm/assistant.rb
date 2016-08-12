class Crm::Assistant < ActiveRecord::Base
  has_many :contacts,    dependent: :destroy
  has_many :obligations, dependent: :destroy
  has_many :meetings,    dependent: :destroy
  has_many :tasks,       dependent: :destroy

  belongs_to :user
  validates_presence_of :user

  PERSONALITIES = [["Servile", 1]]

  def username
    self.user.username
  end

  def has_closed_obligations?
    obligations.select{ |x| x.status_id == Crm::Obligation::STATUS_COMPLETE ||
                            x.status_id == Crm::Obligation::STATUS_BYPASSED }.size > 0
  end

  def has_closed_tasks?
    tasks.select{ |x| x.status_id == Crm::Task::STATUS_COMPLETE ||
                      x.status_id == Crm::Task::STATUS_BYPASSED }.size > 0
  end

end
