class AddFreeOnSignupFlagToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :free_on_signup, :boolean, default: false

    if snapback = Store::Product.where( title: "Snapback: Fuseki" ).take
      snapback.free_on_signup = true
      snapback.save
    end

  end
end
