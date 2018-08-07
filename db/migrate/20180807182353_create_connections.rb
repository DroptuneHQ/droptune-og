class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.string :uid
      t.string :provider
      t.string :settings
      t.references :user
      t.timestamps
    end
  end
end
