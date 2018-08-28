class AddGeneralizedNudgeFieldForUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nudges, :hstore, default: nil
  end
end
