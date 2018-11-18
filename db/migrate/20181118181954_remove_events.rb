class RemoveEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :artists, :songkick_last_updated_at, :datetime
    remove_column :users, :location, :string
    drop_table :events
  end
end
