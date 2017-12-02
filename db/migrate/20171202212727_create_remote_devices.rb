class CreateRemoteDevices < ActiveRecord::Migration
  def change
    create_table :remote_devices do |t|
      t.integer :remote_device_id, null: false
      t.string  :ip_address
      t.integer :user_id, null: false
    end
  end
end
