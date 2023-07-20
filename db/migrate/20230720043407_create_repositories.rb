class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :owner_login
      t.string :html_url
      t.boolean :private
      # t.datetime :updated_at
      t.datetime :pushed_at

      t.timestamps
    end
  end
end
