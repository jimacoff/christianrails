class AddClosingFieldsToMeetings < ActiveRecord::Migration
  def change
    add_column :crm_meetings, :closed_at, :datetime

    rename_column :crm_obligations, :completed_at, :closed_at

  end
end
