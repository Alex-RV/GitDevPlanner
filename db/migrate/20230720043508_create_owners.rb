class CreateOwners < ActiveRecord::Migration[6.1]
  def change
    create_table :owners do |t|
      t.string :login
      t.string :html_url

      t.timestamps
    end
  end
end
