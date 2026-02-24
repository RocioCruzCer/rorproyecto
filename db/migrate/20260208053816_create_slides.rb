class CreateSlides < ActiveRecord::Migration[8.1]
  def change
    create_table :slides do |t|
      t.string :title
      t.string :image
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end
end
