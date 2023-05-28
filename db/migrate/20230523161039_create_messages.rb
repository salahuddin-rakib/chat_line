class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :read_state
      t.string :message_text

      t.timestamps
    end
  end
end
