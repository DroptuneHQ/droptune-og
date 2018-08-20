class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.references :artists
      t.string :title
      t.text :summary
      t.string :image_url
      t.string :url
      t.string :source_name
      t.datetime :published_at
      t.integer :invalid_reports
      t.timestamps
    end
  end
end
