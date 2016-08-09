class Crm::Contact < ActiveRecord::Base
  belongs_to :assistant

  def full_name
    name = firstname + " " + lastname unless !firstname || !lastname
    name ||= firstname unless !firstname
    name ||= ""
  end
end
