class AddMoreFieldsToMeeting < ActiveRecord::Migration
  def change
    add_column :crm_meetings, :location, :string, default: ""
  end
end
