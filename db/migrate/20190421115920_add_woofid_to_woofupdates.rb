class AddWoofidToWoofupdates < ActiveRecord::Migration[5.2]
  def change
    add_column :woofupdates, :woof_id, :integer
    add_column :dogwalkdates, :woof_id, :integer
    add_column :breedappts, :woof_id, :integer
  end
end
