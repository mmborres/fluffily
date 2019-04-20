class CreateDogwalkdates < ActiveRecord::Migration[5.2]
  def change
    create_table :dogwalkdates do |t|
      t.integer :dog_request_id
      t.integer :dog_accept_id
      t.text :status
      t.date :walkdate
      t.text :place
      t.text :image

      t.timestamps
    end
  end
end
