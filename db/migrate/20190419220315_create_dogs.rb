class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.date :dob
      t.text :name
      t.text :image
      t.text :sex
      t.text :breed
      t.text :color
      t.integer :user_id
      t.text :location
      t.text :imagewithowner

      t.timestamps
    end
  end
end
