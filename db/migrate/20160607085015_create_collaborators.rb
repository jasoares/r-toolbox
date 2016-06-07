class CreateCollaborators < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborators do |t|
      t.string :name
      t.timestamps
    end

    add_index :collaborators, :name, unique: true
  end
end
