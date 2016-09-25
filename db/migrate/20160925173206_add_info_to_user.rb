class AddInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :device_token, :string, null: false
  	add_column :users, :platform, :integer, null: false, default: 0
  end
end
