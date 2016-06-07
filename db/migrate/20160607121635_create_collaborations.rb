class CreateCollaborations < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborations do |t|
      t.boolean :author, default: false
      t.boolean :contributor, default: false
      t.boolean :creator, default: false
      t.boolean :copyright_holder, default: false
      t.references :collaborator, foreign_key: true
      t.references :version, foreign_key: true
    end

    add_index :collaborations, [:version_id, :collaborator_id], unique: true
  end
end
