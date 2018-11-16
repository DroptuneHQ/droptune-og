class DropNewsTable < ActiveRecord::Migration[5.2]
  def up
  	execute 'drop table if exists news'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
