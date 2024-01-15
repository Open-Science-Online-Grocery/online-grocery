class CreateCartAndCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :temp_carts do |t|
      t.string :condition_identifier
      t.string :session_id
      t.string :pop_up_message

      t.timestamps
    end

    create_table :cart_items do |t|
      t.references :product
      t.references :temp_cart
      t.integer :quantity

      t.timestamps
    end
  end
end
