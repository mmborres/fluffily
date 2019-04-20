class CreateBreedappts < ActiveRecord::Migration[5.2]
  def change
    create_table :breedappts do |t|
      t.integer :dog_request_id
      t.integer :dog_accept_id
      t.text :status
      t.date :breeddate
      t.text :place
      t.text :image

      t.timestamps
    end
  end
end
