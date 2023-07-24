class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :repository_id
      t.string :name
      t.string :owner_login
      t.string :html_url
      t.string :private
      t.string :updated_repo_at
      t.string :pushed_at
      t.string :last_commit_date
      t.string :last_commit_sha
      t.string :last_commit_message
      t.string :last_commit_author
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
