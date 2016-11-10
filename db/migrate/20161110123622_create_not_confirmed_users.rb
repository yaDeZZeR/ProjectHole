class CreateNotConfirmedUsers < ActiveRecord::Migration
  def change
    create_table :not_confirmed_users do |t|
      t.string :login, null: false
      t.string :password, null: false
      t.timestamps null: false
    end
  end
end
