class CreateCollaborators < ActiveRecord::Migration[6.1]
  def change
    create_table :collaborators do |t|
      t.string :login
      t.string :avatar_url
      t.string :html_url

      t.timestamps
    end
  end
end
