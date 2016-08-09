class Crm::Contact < ActiveRecord::Base
  belongs_to :assistant

  def full_name
    name = firstname + " " + lastname unless !firstname || !lastname
    name ||= firstname unless !firstname
    name ||= ""
  end

  def position_at_business
    if positiontitle && positiontitle != "" && business && business != ""
      positiontitle + ", " + business
    elsif positiontitle && positiontitle != ""
      positiontitle
    else
      business
    end
  end
end
