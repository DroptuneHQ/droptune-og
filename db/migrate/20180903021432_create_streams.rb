class CreateStreams < ActiveRecord::Migration[5.2]
  def change
    create_table :streams do |t|
      t.references :user
      t.references :artist
      t.references :album
      t.string :name
      t.datetime :listened_at
      t.string :source
      t.timestamps
    end
  end
end
