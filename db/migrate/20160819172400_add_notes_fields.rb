class AddNotesFields < ActiveRecord::Migration
  def change
    add_column :crm_meetings, :notes, :text
    add_column :crm_ideas, :notes, :text
    add_column :crm_tasks, :notes, :text
    add_column :crm_obligations, :notes, :text
  end
end
