class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.string :from_user_type
      t.integer :to_user_id
      t.string :to_user_type
      t.integer :read_state
      t.string :message_text

      t.timestamps
    end
  end
end
