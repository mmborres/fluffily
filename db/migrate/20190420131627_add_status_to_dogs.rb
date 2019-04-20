class AddStatusToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :status, :text
  end
end
