class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :user_id, null: false
      t.decimal :lat, precision: 15, scale: 10, null: false
      t.decimal :lng, precision: 15, scale: 10, null: false
      t.decimal :distance, precision: 15
      t.timestamps null: false
    end
    add_index :locations, :user_id
    add_index :locations, :lat
    add_index :locations, :lng
  end
end
