class AddTokenToNotConfirmedUser < ActiveRecord::Migration
  def change
  	add_column :not_confirmed_users, :token, :string, null: false
  end
end
