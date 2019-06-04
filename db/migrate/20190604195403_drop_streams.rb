class DropStreams < ActiveRecord::Migration[5.2]
  def change
    drop_table :streams
  end
end
