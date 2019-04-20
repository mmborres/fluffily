class AddMoreToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :pref_sex, :text
    add_column :dogs, :pref_breed, :text
    add_column :dogs, :pref_color, :text
    add_column :dogs, :pref_location, :text
  end
end
