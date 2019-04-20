class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :email
      t.text :password_digest
      t.date :dob
      t.boolean :admin
      t.text :name
      t.text :image
      t.text :sex
      t.boolean :has_registered_dog

      t.timestamps
    end
  end
end
