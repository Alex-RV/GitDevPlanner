class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :done, default: false
      t.references :repository, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
