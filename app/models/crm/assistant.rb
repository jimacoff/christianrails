class Crm::Assistant < ApplicationRecord
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

  EMAIL_SEND_TIME = 7#AM

  def time_zone=(val)
    self.user.time_zone = val
    self.user.save
  end

  def time_zone
    self.user ? self.user.time_zone : "UTC"
  end

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
    meetings.where('date_time > ?', DateTime.current)
            .where('date_time < ?', DateTime.current + 1.day)
            .where(status_id: Crm::Meeting::STATUS_FORTHCOMING)
            .sort{ |a, b| a.date_time <=> b.date_time }
  end

  def todays_obligations
    obligations.where('due_at < ?', DateTime.current + 1.day)
               .where(status_id: Crm::Obligation::STATUS_OPEN)
               .sort{ |a, b| a.due_at <=> b.due_at }
  end

  def todays_tasks
    tasks.where('due_at < ?', DateTime.current + 1.day)
         .where(status_id: Crm::Task::STATUS_OPEN)
         .sort{ |a, b| a.due_at <=> b.due_at }
  end

  def nothing_to_do_today?
    todays_meetings.size == 0 &&
    todays_obligations.size == 0 &&
    todays_tasks.size == 0
  end

  def total_activity_volume
    obligations.size + tasks.size + meetings.size
  end

  def open_activity_volume
    obligations.select{ |x| x.status_id == Crm::Obligation::STATUS_OPEN }.size +
    meetings.select{ |x| x.status_id == Crm::Meeting::STATUS_FORTHCOMING }.size +
    tasks.select{ |x| x.status_id == Crm::Task::STATUS_OPEN }.size
  end

  def ripe_for_email?
    puts "Assistant's hour: #{Time.current.in_time_zone( self.user.time_zone ).hour}"
    Time.current.in_time_zone( self.user.time_zone ).hour == EMAIL_SEND_TIME
  end

  # TODO add some randomizers for books, ideas etc.

end
