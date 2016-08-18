class Crm::Assistant < ActiveRecord::Base
  has_many :contacts,    dependent: :destroy
  has_many :obligations, dependent: :destroy
  has_many :meetings,    dependent: :destroy
  has_many :tasks,       dependent: :destroy
  has_many :ideas,       dependent: :destroy
  has_many :books,       dependent: :destroy
  has_many :mailouts,    dependent: :destroy

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

  def has_closed_meetings?
    meetings.select{ |x| x.status_id == Crm::Meeting::STATUS_COMPLETE ||
                         x.status_id == Crm::Meeting::STATUS_BYPASSED }.size > 0
  end

  def has_closed_tasks?
    tasks.select{ |x| x.status_id == Crm::Task::STATUS_COMPLETE ||
                      x.status_id == Crm::Task::STATUS_BYPASSED }.size > 0
  end

  def has_closed_ideas?
    ideas.select{ |x| x.status_id == Crm::Idea::STATUS_COMPLETE ||
                      x.status_id == Crm::Idea::STATUS_ABANDONED }.size > 0
  end

  def has_read_books?
    books.select{ |x| x.status_id == Crm::Book::STATUS_READ }.size > 0
  end

  def todays_meetings
    meetings.where('date_time > ?', DateTime.now)
            .where('date_time < ?', DateTime.now + 1.day)
            #.sort( |a, b| a.date_time <=> b.date_time )
  end

  def todays_obligations
    obligations.where('due_at > ?', DateTime.now)
               .where('due_at < ?', DateTime.now + 1.day)
               #.sort( |a, b| a.date_time <=> b.date_time )
  end

  def todays_tasks
    tasks.where('due_at > ?', DateTime.now)
         .where('due_at < ?', DateTime.now + 1.day)
         #.sort( |a, b| a.date_time <=> b.date_time )
  end

  def nothing_to_do_today?
    todays_meetings.size == 0 &&
    todays_obligations.size == 0 &&
    todays_tasks.size == 0
  end

  # TODO add some randomizers for books, ideas etc.

end
