class AddPlayers < ActiveRecord::Migration
  def change
    create_table :woods_players do |t|

      t.string :name
      t.integer :silver_coins
      t.string :password
      t.string :image

      t.integer :gold_coins
      t.string :session_id
      t.integer :karma
      t.string :email



      t.integer :most_recent_story
      t.datetime :joined
      t.integer :weight
      t.string :description
      t.integer :membership_level
      t.integer :total_equity
      t.integer :story_limit
      t.integer :item_limit
      t.integer :palette_limit

      t.datetime :last_login
      t.boolean :email_consent
      t.boolean :consent_to_email

      t.timestamps

    end

  end
end
