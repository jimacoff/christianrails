class AddCompletedAtToObligations < ActiveRecord::Migration
  def change
    add_column :crm_obligations, :completed_at, :datetime
  end
end
