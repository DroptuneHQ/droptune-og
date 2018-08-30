class DropNewsTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :news
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
