class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :notable, polymorphic: true

      t.timestamps
    end
  end
end
