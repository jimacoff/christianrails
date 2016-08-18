class AddAgendaFieldToMeetings < ActiveRecord::Migration
  def change
    add_column :crm_meetings, :agenda, :text
  end
end
