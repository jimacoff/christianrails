class AddFreeOnSignupFlagToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :free_on_signup, :boolean, default: false
  end
end
