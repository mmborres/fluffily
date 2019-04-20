class CreateWoofs < ActiveRecord::Migration[5.2]
  def change
    create_table :woofs do |t|
      t.integer :dog_request_id
      t.integer :dog_accept_id
      t.text :status

      t.timestamps
    end
  end
end
