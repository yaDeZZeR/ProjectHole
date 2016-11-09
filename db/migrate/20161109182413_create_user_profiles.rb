class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id, null: false
      t.string :last_name, null: false, default: ""
      t.string :first_name, null: false, default: ""
      t.datetime :birthday, null: false
      t.integer :sex, null: false, default: 0
      t.integer :height, default: 0
      t.string :email, default: ""
      t.integer :hair_color_id
      t.timestamps null: false
    end
    add_index :user_profiles, :user_id
    add_index :user_profiles, :birthday
    add_index :user_profiles, :sex
    add_index :user_profiles, :height
    add_index :user_profiles, :hair_color_id
  end
end
