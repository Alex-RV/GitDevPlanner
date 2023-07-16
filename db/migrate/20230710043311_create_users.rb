class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :uid
      t.string :github_access_token
      t.string :avatar_url
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
