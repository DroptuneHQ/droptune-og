class ChangeNullRestrictionOnUsersEmail < ActiveRecord::Migration[5.2]
  def up
    enable_extension('citext')
    change_column :users, :email, :citext, null: true
  end

  def down
    change_column :users, :email, :string, null: false
    disable_extension('citext')
  end
end
