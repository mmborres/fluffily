class CreatePreferences < ActiveRecord::Migration[5.2]
  def change
    create_table :preferences do |t|
      t.integer :dog_id
      t.text :sex
      t.text :breed
      t.text :color
      t.text :location

      t.timestamps
    end
  end
end
