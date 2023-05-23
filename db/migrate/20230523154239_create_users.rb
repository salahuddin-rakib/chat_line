class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :admin_id
      t.integer :user_type, default: 0
      t.integer :status, default: 0
      t.string :full_name
      t.string :email
      t.string :profile_photo
      t.string :phone_number
      t.string :password_digest

      t.timestamps
    end
  end
end
