class SetDefaultsForTasks < ActiveRecord::Migration
  def change
    change_column :crm_tasks, :type_id, :integer, default: 0
    change_column :crm_tasks, :recurral_period, :integer,  default: 30
    change_column :crm_tasks, :recurral_weekday, :integer,  default: 0
    change_column :crm_tasks, :recurral_monthday, :integer,  default: 1
  end
end
