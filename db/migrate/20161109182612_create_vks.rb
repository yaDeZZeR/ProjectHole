class CreateVks < ActiveRecord::Migration
  def change
    create_table :vks do |t|
      t.string :user_id, null: false
      t.string :vk_id, null: false
      t.timestamps null: false
    end
    add_index :vks, :vk_id
    add_index :vks, :user_id
  end
end
