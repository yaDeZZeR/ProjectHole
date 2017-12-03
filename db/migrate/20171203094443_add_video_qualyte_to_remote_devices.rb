class AddVideoQualyteToRemoteDevices < ActiveRecord::Migration
  def change
  	add_column :remote_devices, :video_qualite, :integer, default: 0
  	add_column :remote_devices, :name, :string
  	remove_column :remote_devices, :remote_device_id
  end
end
