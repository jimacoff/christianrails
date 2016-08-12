class AddBooksTable < ActiveRecord::Migration
  def change
    create_table :crm_books do |t|

      t.integer :assistant_id
      t.string :title
      t.string :author
      t.integer :desire_to_read
      t.integer :status_id, default: 0
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
