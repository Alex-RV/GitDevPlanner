class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :uid
      t.string :github_access_token
      # Add any additional columns you need for the "users" table
      t.timestamps
    end
  end
end
