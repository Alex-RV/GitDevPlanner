class ChangeRepositoryDataTypes < ActiveRecord::Migration[6.1]
  def change
    # Convert existing data to the correct data types
    change_column :repositories, :updated_repo_at, :datetime, using: 'updated_repo_at::timestamp without time zone'
    change_column :repositories, :pushed_at, :datetime, using: 'pushed_at::timestamp without time zone'
    change_column :repositories, :last_commit_date, :datetime, using: 'last_commit_date::timestamp without time zone'

    # Change data types for columns storing text information
    change_column :repositories, :last_commit_message, :text
    change_column :repositories, :last_commit_author, :text
  end
end
