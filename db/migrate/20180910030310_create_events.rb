class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :artist
      t.string :postal_code
      t.string :city
      t.string :region
      t.string :country
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :lng, precision: 15, scale: 10
      t.datetime :starts_at
      t.decimal :price
      t.string :venue_name
      t.string :venue_address
      t.integer :eventful_popularity
      t.string :eventful_id
      t.string :eventful_url
      t.string :eventful_ticket_url
      t.timestamps
    end
  end
end
