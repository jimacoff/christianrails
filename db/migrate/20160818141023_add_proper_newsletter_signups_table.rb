class AddProperNewsletterSignupsTable < ActiveRecord::Migration
  def change
    create_table :newsletter_signups do |t|

      t.string  :email
      t.integer :newsletters_received, default: 0

      t.timestamps null: false
    end
  end
end
