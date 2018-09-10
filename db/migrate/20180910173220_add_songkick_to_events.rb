class AddSongkickToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :songkick_popularity, :decimal, precision: 15, scale: 10
    add_column :events, :songkick_id, :integer
    add_column :events, :songkick_url, :string
    add_column :events, :songkick_ticket_url, :string
    add_column :artists, :songkick_last_updated_at, :datetime
  end
end
