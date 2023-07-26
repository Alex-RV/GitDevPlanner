class CreateCollaborators < ActiveRecord::Migration[6.1]
  def change
    create_table :collaborators do |t|
      t.integer :collaborator_id
      t.string :login
      t.string :avatar_url
      t.string :html_url
      t.text :subscriptions, array: true, default: []
      t.text :organizations, array: true, default: []
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
