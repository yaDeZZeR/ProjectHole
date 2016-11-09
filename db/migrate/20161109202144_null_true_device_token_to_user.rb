class NullTrueDeviceTokenToUser < ActiveRecord::Migration
  def change
  	change_column :users, :device_token, :string, null: true
  end
end
