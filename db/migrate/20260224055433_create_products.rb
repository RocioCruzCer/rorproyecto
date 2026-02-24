# db/migrate/XXXXXXXXXXXXXX_create_products.rb
class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :brand, null: false

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :category
    add_index :products, :brand
  end
end
