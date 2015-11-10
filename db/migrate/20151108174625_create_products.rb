class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :title
      t.string  :author
      t.string  :short_desc
      t.text    :long_desc
      t.decimal :price

      t.timestamps null: false
    end
  end
end
