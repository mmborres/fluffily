class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :woof_id
      t.integer :sender_id
      t.text :sender_name
      t.text :message_text

      t.timestamps
    end
  end
end
