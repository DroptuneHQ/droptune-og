class SwitchNamesToCitext < ActiveRecord::Migration[5.2]
  def up
    change_column :artists, :name, :citext
    change_column :albums, :name, :citext
  end

  def down
    change_column :artists, :name, :text
    change_column :albums, :name, :text
  end
end
