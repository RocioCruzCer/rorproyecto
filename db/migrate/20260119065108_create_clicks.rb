class CreateClicks < ActiveRecord::Migration[8.1]
  def change
    create_table :clicks do |t|
      t.integer :count, default: 0
      t.timestamps
    end
  end
end