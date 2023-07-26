class CreateOwners < ActiveRecord::Migration[6.1]
  def change
    create_table :owners do |t|
      t.integer :owner_id
      t.string :login
      t.string :html_url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
